class CreateRooms < ActiveRecord::Migration[6.1]
  def change
    create_table :rooms do |t|
      t.string :room_id
      t.string :red_player_id
      t.string :blue_player_id
      t.boolean :room_status
      t.boolean :next_turn
      t.boolean :is_game_over

      t.timestamps
    end
  end
end
