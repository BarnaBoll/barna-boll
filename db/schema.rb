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

ActiveRecord::Schema[8.1].define(version: 2025_12_13_104636) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "cities", force: :cascade do |t|
    t.string "color"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.string "slug"
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_cities_on_slug", unique: true
  end

  create_table "locations", force: :cascade do |t|
    t.string "address"
    t.bigint "city_id", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id"], name: "index_locations_on_city_id"
  end

  create_table "matches", force: :cascade do |t|
    t.bigint "city_id", null: false
    t.datetime "created_at", null: false
    t.date "date"
    t.text "description"
    t.integer "hard_limit_total", null: false
    t.bigint "location_id", null: false
    t.decimal "price", precision: 8, scale: 2
    t.integer "reminder_offset_minutes"
    t.datetime "reminder_sent_at"
    t.integer "soft_limit_per_team", default: 5, null: false
    t.integer "teams_count", default: 3, null: false
    t.time "time"
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id"], name: "index_matches_on_city_id"
    t.index ["location_id"], name: "index_matches_on_location_id"
  end

  create_table "player_stats", force: :cascade do |t|
    t.bigint "city_id", null: false
    t.datetime "created_at", null: false
    t.bigint "location_id", null: false
    t.integer "losses", default: 0
    t.integer "matches_played", default: 0
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.integer "wins", default: 0
    t.index ["city_id"], name: "index_player_stats_on_city_id"
    t.index ["location_id"], name: "index_player_stats_on_location_id"
    t.index ["user_id", "city_id", "location_id"], name: "index_stats_unique", unique: true
    t.index ["user_id"], name: "index_player_stats_on_user_id"
  end

  create_table "promotional_emails", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.string "cta_label"
    t.string "cta_url"
    t.text "intro"
    t.datetime "send_at"
    t.datetime "sent_at"
    t.string "subject", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
  end

  create_table "registrations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.jsonb "present_member_ids", default: [], null: false
    t.integer "status", default: 0, null: false
    t.bigint "team_id", null: false
    t.integer "team_size", default: 1, null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "user_team_id"
    t.index ["team_id"], name: "index_registrations_on_team_id"
    t.index ["user_id"], name: "index_registrations_on_user_id"
    t.index ["user_team_id"], name: "index_registrations_on_user_team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.integer "capacity_hard"
    t.integer "capacity_soft", default: 5
    t.datetime "created_at", null: false
    t.bigint "match_id", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["match_id"], name: "index_teams_on_match_id"
  end

  create_table "user_team_memberships", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.bigint "user_team_id", null: false
    t.index ["user_id", "user_team_id"], name: "index_user_team_memberships_on_user_id_and_user_team_id", unique: true
    t.index ["user_id"], name: "index_user_team_memberships_on_user_id"
    t.index ["user_team_id"], name: "index_user_team_memberships_on_user_team_id"
  end

  create_table "user_teams", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "creator_id", null: false
    t.text "description"
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_user_teams_on_creator_id"
  end

  create_table "users", force: :cascade do |t|
    t.boolean "admin", default: false, null: false
    t.datetime "confirmation_sent_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "created_at", null: false
    t.datetime "current_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.integer "failed_attempts", default: 0, null: false
    t.datetime "last_sign_in_at"
    t.string "last_sign_in_ip"
    t.datetime "locked_at"
    t.string "name", null: false
    t.string "provider"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "sign_in_count", default: 0, null: false
    t.string "uid"
    t.string "unconfirmed_email"
    t.string "unlock_token"
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "locations", "cities"
  add_foreign_key "matches", "cities"
  add_foreign_key "matches", "locations"
  add_foreign_key "player_stats", "cities"
  add_foreign_key "player_stats", "locations"
  add_foreign_key "player_stats", "users"
  add_foreign_key "registrations", "teams"
  add_foreign_key "registrations", "user_teams"
  add_foreign_key "registrations", "users"
  add_foreign_key "teams", "matches"
  add_foreign_key "user_team_memberships", "user_teams"
  add_foreign_key "user_team_memberships", "users"
  add_foreign_key "user_teams", "users", column: "creator_id"
end
