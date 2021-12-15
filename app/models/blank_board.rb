class BlankBoard < ApplicationRecord
  has_one :rail_space

  has_many :presets
  has_many :all_chess_per_hands, through: :presets

  has_many :realtime_games
  has_many :hands, through: :realtime_games, source: 'all_chess_per_hand'


  def self.landmine_min_y
    10
  end

  def self.base_camp_type
    'base_camp'
  end

  def self.camp_type
    'camp'
  end
end
