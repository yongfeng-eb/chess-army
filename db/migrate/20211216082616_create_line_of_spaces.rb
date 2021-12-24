class CreateLineOfSpaces < ActiveRecord::Migration[6.1]
  def change
    create_table :line_of_spaces do |t|
      t.integer :one_position_id
      t.integer :two_position_id

      t.timestamps
    end
  end
end
