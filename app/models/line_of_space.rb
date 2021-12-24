class LineOfSpace < ApplicationRecord
  def self.exist_line?(src_position_id, dst_position_id)
    first_line = LineOfSpace.find_by(one_position_id: src_position_id.to_i, two_position_id: dst_position_id.to_i)
    second_line = LineOfSpace.find_by(one_position_id: dst_position_id.to_i, two_position_id: src_position_id.to_i)

    if !first_line.nil? || !second_line.nil?
      '不能走没有线相连的格子'
    else
      ''
    end
  end
end
