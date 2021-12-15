class PresetsController < ApplicationController
  def create
    @has_put_chess = params[:has_put_chess]
    @info_flag = ''
    @current_player_id = params[:user_id]
    @preset_owner_id = params[:preset_owner_id]

    if !params[:first_access].nil?

      # first access
      @has_put_chess = ''
      @user_id = params[:user_id]
      player = Player.find_by(user_id: @user_id)

      new_preset = player.preset_owners.create
      new_preset.update(preset_id: new_preset.id)
      @preset_owner_id = new_preset.id
      Preset.prepare_chess(@preset_owner_id)
    else
      first_clicked_chess = params[:clicked_chess]
      if !first_clicked_chess.nil?
        # handle first click
        @first_clicked_chess_id = first_clicked_chess
      else
        # handle second click
        first_clicked_chess = params[:first_clicked_chess].to_i
        second_clicked_space = params[:put_chess_position].to_i

        @put_chess_position = params[:put_chess_position]

        is_obey_rules = check_conform_rules(first_clicked_chess, second_clicked_space)

        if !is_obey_rules.nil?
          @info_flag = is_obey_rules
          @first_clicked_chess_id = ''
        else
          Preset.find_by(preset_owner_id: @preset_owner_id, all_chess_per_hand_id: first_clicked_chess)
                .update(blank_board_id: second_clicked_space, is_placed: true)
          @has_put_chess += "#{first_clicked_chess},"
        end
      end
    end

    render_place_chess
  end
end

def check_conform_rules(first_button, second_button)
  chess_id = AllChessPerHand.find(first_button).chess.chess_id
  position = BlankBoard.find(second_button)

  if chess_id == Chess.landmine_chess_id && position.y_position < BlankBoard.landmine_min_y
    '地雷只能放在最后两行'
  elsif chess_id == Chess.ensign_chess_id && position.position_type != BlankBoard.base_camp_type
    '军旗只能放在大本营'
  elsif position.position_type == BlankBoard.camp_type
    '行营中不能放棋子'
  end
end

def render_place_chess
  @chess_per_preset = Preset.where(preset_owner_id: @preset_owner_id)
  @all_chess = AllChessPerHand.all
  @chess_names = []

  @chess_per_preset.each do |chess|
    @chess_names.append(chess.all_chess_per_hand.chess.chess_name)
  end

  @board_content = Array.new(30) { '' }
  i = 0
  @all_blank_board = BlankBoard.where('position_id>30')
  @all_blank_board.each do |space|
    tmp = Preset.find_by(preset_owner_id: @preset_owner_id, blank_board_id: space.position_id)
    @board_content[i] = '行营' if tmp.nil? && space.position_type == 'camp'
    @board_content[i] = tmp.all_chess_per_hand.chess.chess_name unless tmp.nil?
    i += 1
  end

  @element_count_inline = 0
  @vertical_count = 0
end
