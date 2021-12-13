class CreateChesses < ActiveRecord::Migration[6.1]
  def change
    create_table :chesses do |t|
      t.integer :chess_id
      t.string :chess_name
      t.integer :chess_priority

      t.timestamps
    end

    create_table :all_chess_per_hands do |t|
      t.belongs_to :chess, index: true, foreign_key: true
      t.timestamps
    end
  end
end
