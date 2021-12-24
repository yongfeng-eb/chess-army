class CreatePlayers < ActiveRecord::Migration[6.1]
  def change
    create_table :players do |t|
      t.string :user_id
      t.string :player_name
      t.string :password
      t.boolean :is_login
      t.boolean :is_gaming

      t.timestamps
    end

    create_table :preset_owners do |t|
      t.belongs_to :player, index: true, foreign_key: true
      t.integer :preset_id

      t.timestamps
    end

    create_table :presets do |t|
      t.belongs_to :preset_owner, index: true, foreign_key: true
      t.belongs_to :all_chess_per_hand
      t.belongs_to :blank_board

      t.timestamps
    end

  end
end
