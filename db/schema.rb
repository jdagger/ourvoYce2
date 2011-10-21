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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111013130316) do

  create_table "favorites", :force => true do |t|
    t.integer  "user_id"
    t.integer  "item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", :force => true do |t|
    t.string  "name"
    t.string  "item_type"
    t.string  "description"
    t.string  "logo"
    t.string  "wikipedia"
    t.string  "website"
    t.integer "default_order",          :default => 1000
    t.integer "lock_version",           :default => 0
    t.integer "thumbs_up_vote_count",   :default => 0
    t.integer "thumbs_down_vote_count", :default => 0
    t.integer "neutral_vote_count",     :default => 0
    t.integer "total_vote_count",       :default => 0
  end

  create_table "stats", :force => true do |t|
    t.integer "item_id"
    t.integer "birth_year"
    t.string  "state"
    t.string  "zip"
    t.integer "lock_version",           :default => 0
    t.integer "thumbs_up_vote_count",   :default => 0
    t.integer "thumbs_down_vote_count", :default => 0
    t.integer "neutral_vote_count",     :default => 0
    t.integer "total_vote_count",       :default => 0
  end

  add_index "stats", ["item_id", "birth_year", "zip"], :name => "index_stats_on_item_id_and_birth_year_and_zip", :unique => true

  create_table "tag_items", :force => true do |t|
    t.integer "tag_id"
    t.integer "item_id"
  end

  create_table "tags", :force => true do |t|
    t.string  "path"
    t.string  "friendly_name"
    t.boolean "popular",       :default => false
    t.boolean "hot_topic",     :default => false
  end

  create_table "user_votes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "item_id"
    t.integer  "vote"
    t.integer  "lock_version", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_votes", ["item_id", "user_id"], :name => "index_user_votes_on_item_id_and_user_id", :unique => true

  create_table "users", :force => true do |t|
    t.string  "email"
    t.string  "password_digest"
    t.string  "country"
    t.string  "zip"
    t.string  "state"
    t.integer "birth_year"
    t.date    "member_since"
    t.boolean "confirmed"
  end

  create_table "zips", :force => true do |t|
    t.string "zip"
    t.string "latitude"
    t.string "longitude"
    t.string "city"
    t.string "state"
  end

  add_index "zips", ["zip"], :name => "index_zips_on_zip"

end
