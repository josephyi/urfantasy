# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150407011620) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "urf_day_stats", force: :cascade do |t|
    t.integer "champion_id"
    t.string  "region"
    t.integer "urf_day"
    t.integer "hour_in_day"
    t.integer "kills"
    t.integer "deaths"
    t.integer "assists"
    t.integer "double_kills"
    t.integer "triple_kills"
    t.integer "quadra_kills"
    t.integer "penta_kills"
    t.integer "killing_spree_max"
    t.integer "first_blood"
    t.integer "minions_killed"
    t.integer "bans"
    t.integer "wins"
    t.integer "losses"
    t.integer "mirror_matches"
  end

  add_index "urf_day_stats", ["champion_id", "urf_day", "hour_in_day", "region"], name: "urf_day_stats_idx", using: :btree

  create_table "urf_ids_requests", force: :cascade do |t|
    t.string   "region"
    t.integer  "bucket_time"
    t.json     "response"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "urf_ids_requests", ["region", "bucket_time"], name: "index_urf_ids_requests_on_region_and_bucket_time", using: :btree

  create_table "urf_matches", force: :cascade do |t|
    t.string   "region"
    t.integer  "match_id"
    t.integer  "bucket_time"
    t.jsonb    "response"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "urf_matches", ["region", "bucket_time"], name: "urf_match_region_bucket_time_idx", order: {"bucket_time"=>:desc}, using: :btree
  add_index "urf_matches", ["region", "match_id", "bucket_time"], name: "index_urf_matches_on_region_and_match_id_and_bucket_time", using: :btree
  add_index "urf_matches", ["response"], name: "urf_matches_gin_path_idx", using: :gin

end
