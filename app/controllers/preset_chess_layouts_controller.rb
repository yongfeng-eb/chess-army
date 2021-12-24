class PresetChessLayoutsController < ApplicationController
  def choose
    @room_id = params[:room_id]
    @create_room_player_id = params[:user_id]
    @join_room_player_id = params[:join_room_player_id]

    unless @join_room_player_id.nil?
      current_room = Room.find_by(room_id: @room_id)
      current_room.update(blue_player_id: @join_room_player_id,
                          room_status: false)
    end

    @which_hand = params[:which_hand]
    @player_detail = if @which_hand.to_s == 'red_hand'
                       "red:#{@create_room_player_id}"
                     else
                       "blue:#{@join_room_player_id}"
                     end

    current_player_id = if @create_room_player_id.nil?
                          @join_room_player_id
                        else
                          @create_room_player_id
                        end

    player = Player.find_by(user_id: current_player_id)
    @own_preset_ids = []
    player.preset_owners.each do |own|
      @own_preset_ids.append(own.preset_id)
    end
  end

  def prepared
    @user_id = params[:user_id]

    @room_id = params[:room_id]
    @player_detail = params[:player_detail]
    @chosen_preset_id = params[:chosen_preset_id]

    @red_or_blue = @player_detail.split(':')[0]
    @realtime_game = Array.new(60) { { '': '' } } # {'chess_name': 'red'}, {'chess_name': 'blue'}

    all_blank_board = BlankBoard.all
    all_chess = Preset.where(preset_owner_id: @chosen_preset_id.to_i).order(:blank_board_id)
    all_chess.each do |chess|
      if @red_or_blue == 'blue'
        @realtime_game[chess.blank_board_id - 1] = {
          'chess_id' => chess.all_chess_per_hand.chess.chess_id,
          chess.all_chess_per_hand.chess.chess_name => @red_or_blue,
          'position_id' => chess.blank_board_id,
          'position_type' => chess.blank_board.position_type
        }
      else
        @realtime_game[60 - chess.blank_board_id] = {
          'chess_id' => chess.all_chess_per_hand.chess.chess_id,
          chess.all_chess_per_hand.chess.chess_name => @red_or_blue,
          'position_id' => 61 - chess.blank_board_id,
          'position_type' => chess.blank_board.position_type
        }
      end
    end

    all_blank_board.each do |board|
      next unless board.position_type == BlankBoard.camp_type

      @realtime_game[board.position_id - 1] = {
        'chess_id' => 13,
        '行营' => 'middle',
        'position_id' => board.position_id,
        'position_type' => BlankBoard.camp_type
      }
    end
  end
end
