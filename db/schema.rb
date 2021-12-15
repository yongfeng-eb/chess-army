# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_12_14_083529) do

  create_table "all_chess_per_hands", charset: "latin1", force: :cascade do |t|
    t.bigint "chess_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["chess_id"], name: "index_all_chess_per_hands_on_chess_id"
  end

  create_table "bb", charset: "latin1", force: :cascade do |t|
    t.integer "position_id"
    t.integer "x_position"
    t.integer "y_position"
    t.string "position_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "blank_boards", charset: "latin1", force: :cascade do |t|
    t.integer "position_id"
    t.integer "x_position"
    t.integer "y_position"
    t.string "position_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "chesses", charset: "utf8mb4", force: :cascade do |t|
    t.integer "chess_id"
    t.string "chess_name"
    t.integer "chess_priority"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "leader_boards", charset: "latin1", force: :cascade do |t|
    t.bigint "player_id"
    t.integer "win_count"
    t.integer "fail_count"
    t.integer "total_count"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["player_id"], name: "index_leader_boards_on_player_id"
  end

  create_table "players", charset: "latin1", force: :cascade do |t|
    t.string "user_id"
    t.string "player_name"
    t.string "password"
    t.boolean "is_login"
    t.boolean "is_gaming"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "preset_owners", charset: "latin1", force: :cascade do |t|
    t.bigint "player_id"
    t.integer "preset_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["player_id"], name: "index_preset_owners_on_player_id"
  end

  create_table "presets", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "preset_owner_id"
    t.bigint "all_chess_per_hand_id"
    t.bigint "blank_board_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "is_placed"
    t.index ["all_chess_per_hand_id"], name: "index_presets_on_all_chess_per_hand_id"
    t.index ["blank_board_id"], name: "index_presets_on_blank_board_id"
    t.index ["preset_owner_id"], name: "index_presets_on_preset_owner_id"
  end

  create_table "rail_spaces", charset: "latin1", force: :cascade do |t|
    t.bigint "blank_board_id"
    t.string "near_position"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["blank_board_id"], name: "index_rail_spaces_on_blank_board_id"
  end

  create_table "realtime_games", charset: "latin1", force: :cascade do |t|
    t.string "game_id"
    t.bigint "chess_id"
    t.bigint "blank_board_id"
    t.integer "red_or_blue"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["blank_board_id"], name: "index_realtime_games_on_blank_board_id"
    t.index ["chess_id"], name: "index_realtime_games_on_chess_id"
  end

  create_table "rooms", charset: "latin1", force: :cascade do |t|
    t.string "room_id"
    t.string "red_player_id"
    t.string "blue_player_id"
    t.boolean "room_status"
    t.boolean "next_turn"
    t.boolean "is_game_over"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "all_chess_per_hands", "chesses"
  add_foreign_key "preset_owners", "players"
  add_foreign_key "presets", "preset_owners"
end
