class Preset < ApplicationRecord
  belongs_to :preset_owner

  belongs_to :all_chess_per_hand
  belongs_to :blank_board
end
