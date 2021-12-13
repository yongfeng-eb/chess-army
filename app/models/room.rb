class Room < ApplicationRecord
  def self.move_first(room_id)
    begin_turn = rand(1..2)
    room = Room.find_by(room_id: room_id)
    room.next_turn = begin_turn == 1
  end

  def self.check_next_turn(room_id, move_flag)
    room = Room.find_by(room_id: room_id)
    if ((room.next_turn == true) && move_flag == 1) || ((room.next_turn == false) && move_flag.zero?)
      ''
    else
      "It's not your turn."
    end
  end

  def self.update_next_turn(room_id)
    room = Room.find_by(room_id: room_id)
    room.update(next_turn: !room.next_turn)
  end

  def self.game_over?(room_id)
    room = Room.find_by(room_id: room_id)
    room.is_game_over
  end

  def self.delete_one_room(room_id)
    room = Room.find_by(room_id: room_id)
    Room.delete(room.id)
  end

  def self.all_room
    rooms = Room.all
    rooms.each do |room|
      red_player_name = Player.get_name_by_id(room.red_player_id)
      blue_player_name = Player.get_name_by_id(room.blue_player_id)
      room.red_player_id = red_player_name
      room.blue_player_id = blue_player_name
    end
    rooms
  end
end
