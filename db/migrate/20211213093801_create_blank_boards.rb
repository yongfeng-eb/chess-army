class CreateBlankBoards < ActiveRecord::Migration[6.1]
  def change
    create_table :blank_boards do |t|
      t.integer :position_id
      t.integer :x_position
      t.integer :y_position
      t.string :position_type

      t.timestamps
    end

    create_table :rail_spaces do |t|
      t.belongs_to :blank_board
      t.string :near_position

      t.timestamps
    end
  end
end
