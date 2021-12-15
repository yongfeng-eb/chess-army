class AllChessPerHand < ApplicationRecord
  belongs_to :chess

  has_many :presets
  has_many :blank_boards, through: :presets

  has_many :realtime_games
  has_many :hands, through: :realtime_games, source: 'all_chess_per_hand'
end
