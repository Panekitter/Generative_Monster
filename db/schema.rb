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

ActiveRecord::Schema[7.2].define(version: 2025_03_25_094017) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "battles", force: :cascade do |t|
    t.integer "character_1_id"
    t.integer "character_2_id"
    t.text "event", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "winner_name"
    t.integer "winner_user_id"
    t.string "character_1_name"
    t.string "character_2_name"
    t.integer "user_id"
    t.string "user_skill_name"
    t.string "opponent_skill_name"
    t.string "user_skill_description"
    t.string "opponent_skill_description"
    t.index ["user_id"], name: "index_battles_on_user_id"
  end

  create_table "character_creation_logs", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.index ["user_id"], name: "index_character_creation_logs_on_user_id"
  end

  create_table "characters", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.text "description", null: false
    t.integer "hp", null: false
    t.integer "agility", null: false
    t.integer "strength", null: false
    t.integer "intelligence", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image"
    t.string "appearance"
    t.text "description_from_user"
    t.index ["user_id"], name: "index_characters_on_user_id"
  end

  create_table "skills", force: :cascade do |t|
    t.bigint "character_id", null: false
    t.string "name", null: false
    t.string "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id"], name: "index_skills_on_character_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "battle_count", default: 0, null: false
    t.integer "win_count", default: 0, null: false
    t.string "image"
    t.boolean "no_limit", default: false, null: false
  end

  add_foreign_key "battles", "characters", column: "character_1_id", on_delete: :nullify
  add_foreign_key "battles", "characters", column: "character_2_id", on_delete: :nullify
  add_foreign_key "battles", "users", column: "winner_user_id", on_delete: :nullify
  add_foreign_key "battles", "users", on_delete: :cascade
  add_foreign_key "character_creation_logs", "users"
  add_foreign_key "characters", "users"
  add_foreign_key "skills", "characters"
end
