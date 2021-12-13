class BlankBoard < ApplicationRecord
  has_one :rail_space

  has_many :presets
  has_many :all_chess_per_hands, through: :presets

  has_many :realtime_games
  has_many :all_chess_per_hands, through: :realtime_games
end
