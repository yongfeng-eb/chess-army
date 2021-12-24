class Player < ApplicationRecord
  has_many :preset_owners
  has_one :leader_board

  def self.get_name_by_id(id)
    if id != ''
      player = Player.find_by(user_id: id)
      player.player_name
    else
      ''
    end
  end

  def self.get_password_by_id(id)
    player = Player.find_by(user_id: id)
    player.password
  end
end
