class CreateLeaderBoards < ActiveRecord::Migration[6.1]
  def change
    create_table :leader_boards do |t|
      t.belongs_to :player
      t.integer :win_count
      t.integer :fail_count
      t.integer :total_count

      t.timestamps
    end
  end
end
