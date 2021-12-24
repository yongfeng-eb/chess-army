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

  def self.get_type_by_id(id)
    position = BlankBoard.find_by(position_id: id)
    position.position_type
  end

  def self.get_y_by_position_id(id)
    position = BlankBoard.find_by(position_id: id)
    position.y_position
  end

  def self.get_x_by_position_id(id)
    position = BlankBoard.find_by(position_id: id)
    position.x_position
  end
end
