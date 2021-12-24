class Chess < ApplicationRecord
  has_many :all_chess_per_hands

  def self.landmine_chess_id
    11
  end

  def self.ensign_chess_id
    12
  end

  def self.engineer_chess_id
    9
  end

  def self.get_chess_priority(chess_id)
    chess = Chess.find_by(chess_id: chess_id)
    chess.chess_priority
  end

  def self.bomb_priority
    2
  end

  def self.blank_priority
    -1
  end

  def self.ensign_priority
    0
  end

  def self.landmine_priority
    1
  end

  def self.engineer_priority
    3
  end
end
