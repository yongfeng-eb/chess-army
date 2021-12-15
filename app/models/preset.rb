class Preset < ApplicationRecord
  belongs_to :preset_owner

  belongs_to :all_chess_per_hand
  belongs_to :blank_board

  def self.prepare_chess(preset_owner_id)
    all_chess = AllChessPerHand.all
    all_chess.each do |chess|
      preset = Preset.new
      preset.preset_owner_id = preset_owner_id
      preset.all_chess_per_hand_id = chess.id
      preset.blank_board_id = 1
      preset.is_placed = false
      preset.save
    end
  end

  def self.placed_chess(preset_id, red_or_blue)
    if red_or_blue == 'red'
      PresetOwner.find_by(preset_id: preset_id).presets.order(blank_board_id: :desc)
    else
      PresetOwner.find_by(preset_id: preset_id).presets.order(:blank_board_id)
    end
  end

  def self.init_y_position(preset_id, room_id, red_or_blue)
    preset_chess_detail = placed_chess(preset_id, red_or_blue)
    preset_chess_detail.each do |detail|
      which_hand = 1
      which_hand = 0 if red_or_blue == 'blue'
      which_hand = -1 if detail.blank_board.position_type == BlankBoard.camp_type
      RealtimeGame.create(game_id: room_id, all_chess_per_hand_id: detail.all_chess_per_hand_id,
                          blank_board_id: transform_y_position(detail.blank_board_id, red_or_blue),
                          red_or_blue: which_hand)
    end
  end

  def self.transform_y_position(position_id, red_or_blue)
    if red_or_blue == 'red'
      61 - position_id
    else
      position_id
    end
  end
end
