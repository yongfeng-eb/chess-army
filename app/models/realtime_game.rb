class RealtimeGame < ApplicationRecord
  belongs_to :all_chess_per_hand

  def self.engineer_rules(src_position_id, dst_position_id, realtime_game)
    src_position = BlankBoard.find_by(position_id: src_position_id)
    @final_position_id = dst_position_id
    @realtime_game_details = realtime_game

    tmp_near_lattice = src_position.rail_space.near_position
    wait_access_lattices = tmp_near_lattice.split(',')
    visited_lattices = [src_position_id.to_s]

    rules(wait_access_lattices, visited_lattices)

  end

  def self.rules(wait_access_lattices, visited_lattices)
    if wait_access_lattices.empty?
      return 'Can not get to.'
    else
      current_lattice = wait_access_lattices[-1]
      current_position = @realtime_game_details[current_lattice.to_i - 1]
      if current_position.split(' ')[5].to_s == @final_position_id.to_s
        return ''
      elsif current_position.split(' ')[3] != 'middle' && wait_access_lattices.empty?
        return 'There is another chess in the road.'
      end
    end

    wait_access_lattices.pop
    visited_lattices.append(current_lattice)
    if current_position.split(' ')[3].to_s == 'middle'
      near_lattice = get_near_position_by_id(current_lattice)
      near_lattice.split(',').each do |lattice|
        wait_access_lattices.push(lattice) unless visited_lattices.include?(lattice)
      end
    end

    rules(wait_access_lattices, visited_lattices)
  end

  def self.get_near_position_by_id(id)
    space = RailSpace.find_by(blank_board_id: id)
    space.near_position
  end

  def self.blank_in_y?(realtime_game_info, src_position_id, dst_position_id)
    puts '========================'
    puts src_position_id
    puts dst_position_id
    tmp_min = [src_position_id, dst_position_id].min.to_i
    tmp_max = [src_position_id, dst_position_id].max.to_i
    tmp = []
    while tmp_min < tmp_max
      tmp.append(realtime_game_info[tmp_min].split(' ')[3])
      tmp_min += 5
    end
    puts '>>>>>>>>>>'
    puts realtime_game_info
    puts tmp_min
    puts tmp_max
    puts '>>>>>>>>>>'
    puts tmp
    puts '>>>>>>>>>>'
    tmp.delete(realtime_game_info[tmp_min].split(' ')[3])
    tmp.delete(realtime_game_info[tmp_max].split(' ')[3])
    if tmp != []
      tmp.each do |element|
        return false if element != 'middle'
      end
    else
      true
    end
  end

  def self.blank_in_x?(realtime_game_info, src_position_id, dst_position_id)
    tmp_min = [src_position_id, dst_position_id].min.to_i
    tmp_max = [src_position_id, dst_position_id].max.to_i
    tmp = []
    while tmp_min < tmp_max
      tmp.append(realtime_game_info[tmp_min].split(' ')[3])
      tmp_min += 1
    end
    tmp.delete(realtime_game_info[tmp_min].split(' ')[3])
    tmp.delete(realtime_game_info[tmp_max].split(' ')[3])
    if tmp != []
      tmp.each do |element|
        return false if element != 'middle'
      end
    else
      true
    end
  end
end
