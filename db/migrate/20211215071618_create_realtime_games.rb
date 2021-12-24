class CreateRealtimeGames < ActiveRecord::Migration[6.1]
  def change
    create_table :realtime_games do |t|
      t.string :game_id
      t.belongs_to :all_chess_per_hand
      t.belongs_to :blank_board
      t.integer :red_or_blue

      t.timestamps
    end
  end
end
