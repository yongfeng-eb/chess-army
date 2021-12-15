class CreateBlankBoards < ActiveRecord::Migration[6.1]
  def change
    create_table :blank_boards do |t|
      t.integer :position_id
      t.integer :x_position
      t.integer :y_position
      t.string :position_type

      t.timestamps
    end
  end
end
