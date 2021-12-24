class RealtimeGamesController < ApplicationController
  $realtime_game_info = Hash.new { { '': [] } } # {room_id: [{}, {}]}

  def playing
    is_first_access = params[:first_access]
    @clicked_info = ''
    @user_id = params[:user_id]
    @room_id = params[:room_id]
    @player_detail = params[:player_detail]
    which_hand = @player_detail.split(':')[0]
    if !is_first_access.nil?
      # first access
      tmp_realtime_game = params[:realtime_game]
      if which_hand == 'red'
        $realtime_game_info[@room_id] = tmp_realtime_game[0..29]
      else
        tmp_realtime_game[30..].each do |info|
          $realtime_game_info[@room_id].append(info)
        end
      end
      @realtime_game_info = $realtime_game_info
    else
      if Room.game_over?(@room_id)
        redirect_to controller: :game_over, action: :index, user_id: @user_id
      end

      @first_clicked_chess = params[:first_clicked_chess]
      @realtime_game_info = $realtime_game_info

      if @first_clicked_chess.to_s == ''
        # first click
        @first_clicked_chess = params[:clicked_chess]
        @realtime_game_info = $realtime_game_info
      else
        # second click
        first_clicked = params[:first_clicked_chess]
        second_clicked = params[:clicked_chess]
        # both are position_id
        tmp_realtime_detail = @realtime_game_info[@room_id]
        src_chess = tmp_realtime_detail[first_clicked.to_i - 1]
        dst_chess = tmp_realtime_detail[second_clicked.to_i - 1]

        is_obey_rules = check_obey_rules(src_chess, dst_chess, which_hand)

        if is_obey_rules != ''
          @clicked_info = is_obey_rules
          @first_clicked_chess = ''
          @realtime_game_info = $realtime_game_info
          render 'realtime_games/playing'
        else
          @first_clicked_chess = ''
          move_chess_result = move_chess(src_chess.split(' '), dst_chess.split(' '), $realtime_game_info[@room_id])
          handle_move_chess_result(move_chess_result, @room_id)
          Room.update_next_turn(@room_id)
        end
      end
    end
  end

  def handle_move_chess_result(result, room_id)
    if result != ''
      room = Room.find_by(room_id: room_id)
      room.update(is_game_over: true)
      win_player_id = if result == 'red'
                        room.red_player_id
                      else
                        room.blue_player_id
                      end
      both_player_id = [room.red_player_id, room.blue_player_id]
      both_player_id.delete(win_player_id)
      redirect_to controller: :game_over, action: :index, user_id: win_player_id, win_player_id: win_player_id,
                  fail_player_id: both_player_id[0], room_id: room_id, win_hand: result
    end
  end

  # 0: chess_id, 1: 3, 2: 师长, 3: blue, 4: position_id, 5: 31, 6: position_type, 7: railway_space
  def check_obey_rules(src_chess, dst_chess, move_flag)
    # next_turn = Room.check_next_turn(@room_id, move_flag)
    # return next_turn if next_turn != ''

    src_chess_detail = src_chess.split(' ')
    dst_chess_detail = dst_chess.split(' ')
    return 'Please move your own chess.' if src_chess_detail[3] != move_flag && src_chess_detail[3] != 'middle'
    return "Can't eat your own chess." if src_chess_detail[3] == dst_chess_detail[3]
    if dst_chess_detail[-1] == 'camp' && dst_chess_detail[3] != 'middle'
      return "Can't move into camp occupied by other chess ."
    end
    return "Can't move blank." if src_chess_detail[3] == 'middle'

    case src_chess_detail[2]
    when '地雷'
      return "Can't move landmine."
    when '军旗'
      return "Can't move ensign."
    end
    check_moving_rules(src_chess_detail, dst_chess_detail)
  end

  def check_moving_rules(src_chess, dst_chess)
    src_position_type = src_chess[-1]
    dst_position_type = dst_chess[-1]
    # 0: chess_id, 1: 3, 2: 师长, 3: blue, 4: position_id, 5: 31, 6: position_type, 7: railway_space
    src_x_position = BlankBoard.get_x_by_position_id(src_chess[5].to_i)
    src_y_position = BlankBoard.get_y_by_position_id(src_chess[5].to_i)

    dst_x_position = BlankBoard.get_x_by_position_id(dst_chess[5].to_i)
    dst_y_position = BlankBoard.get_y_by_position_id(dst_chess[5].to_i)

    @realtime_game_info[@room_id]
    if src_position_type == 'railway_space' && dst_position_type == 'railway_space'
      if src_chess[1] == Chess.engineer_chess_id.to_s
        RealtimeGame.engineer_rules(src_chess[5].to_i, dst_chess[5].to_i, $realtime_game_info[@room_id])
      elsif (dst_x_position - src_x_position).abs ** 2 + (dst_y_position - src_y_position).abs ** 2 <= 2
        LineOfSpace.exist_line?(src_chess[5], dst_chess[5])
      elsif dst_x_position == src_x_position
        return "Can't step over chess." if RealtimeGame.blank_in_y?(@realtime_game_info[@room_id],
                                                                    src_chess[5],
                                                                    dst_chess[5]) == false

        ''
      elsif src_y_position == dst_y_position
        return "Can't step over chess." if RealtimeGame.blank_in_x?($realtime_game_info[@room_id],
                                                                    src_chess[5],
                                                                    dst_chess[5]) == false

        ''
      else
        "Can't move chess out of a line. (不能转弯)"
      end
    elsif (dst_x_position - src_x_position).abs ** 2 + (dst_y_position - src_y_position).abs ** 2 <= 2
      LineOfSpace.exist_line?(src_chess[5], dst_chess[5])
    else
      "Can't move over one step."
    end
  end

  def move_chess(src_details, dst_details, realtime_info)
    remain_chess = eat_rules(src_details[1], dst_details[1])

    case remain_chess
    when ''
      realtime_info[src_details[5].to_i - 1] = "chess_id 13 '-' middle position_id #{src_details[5]} position_type #{src_details[-1]}"
      realtime_info[dst_details[5].to_i - 1] = "chess_id 13 '-' middle position_id #{dst_details[5]} position_type #{dst_details[-1]}"
      ''
    when 'src'
      tmp_dst_chess_id = dst_details[1]
      tmp_src_chess_hand = src_details[3]
      realtime_info[dst_details[5].to_i - 1] = "chess_id #{src_details[1]} #{src_details[2]} #{src_details[3]} position_id #{dst_details[5]} position_type #{dst_details[-1]}"
      if src_details[-1] == 'camp'
        realtime_info[src_details[5].to_i - 1] = "chess_id 13 '行营' middle position_id #{src_details[5]} position_type #{src_details[-1]}"
      end
      realtime_info[src_details[5].to_i - 1] = "chess_id 13 '-' middle position_id #{src_details[5]} position_type #{src_details[-1]}"

      if tmp_dst_chess_id == Chess.ensign_chess_id.to_s
        tmp_src_chess_hand
      else
        ''
      end
    when 'dst'
      realtime_info[src_details[5].to_i - 1] = "chess_id 13 '-' middle position_id #{src_details[5]} position_type #{src_details[-1]}"
      ''
    end
  end
end

def eat_rules(src, dst)
  src_chess_priority = Chess.get_chess_priority(src)
  dst_chess_priority = Chess.get_chess_priority(dst)

  if (src_chess_priority == dst_chess_priority) ||
    (((src_chess_priority == Chess.bomb_priority && dst_chess_priority != Chess.blank_priority) ||
      dst_chess_priority == Chess.bomb_priority) && dst_chess_priority != Chess.ensign_priority) ||
    (src_chess_priority != Chess.engineer_priority && dst_chess_priority == Chess.landmine_priority)
    ''
  elsif src_chess_priority > dst_chess_priority
    'src'
  else
    'dst'
  end
end

def render_chess
  @room_id = params[:room_id]

  @element_count_inline = 0
  @vertical_count = 0
end