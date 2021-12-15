class Chess < ApplicationRecord
  has_many :all_chess_per_hands

  def self.landmine_chess_id
    11
  end

  def self.ensign_chess_id
    12
  end
end
