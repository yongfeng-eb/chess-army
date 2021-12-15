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
      preset.save
    end
  end
end
