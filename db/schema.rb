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

ActiveRecord::Schema.define(:version => 20120917152222) do

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

  create_table "omniauth_providers", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "qr_lookups", :force => true do |t|
    t.string  "code"
    t.string  "destination"
    t.string  "notes"
    t.integer "counter",     :default => 0
  end

  create_table "states", :force => true do |t|
    t.string "name"
    t.string "abbreviation"
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

  create_table "suggest_topics", :force => true do |t|
    t.integer  "user_id"
    t.string   "ip"
    t.string   "topic"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

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

  add_index "tags", ["friendly_name"], :name => "index_tags_on_friendly_name", :unique => true
  add_index "tags", ["path"], :name => "index_tags_on_path", :unique => true

  create_table "user_tokens", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.string   "country"
    t.string   "zip"
    t.string   "state"
    t.integer  "birth_year"
    t.date     "member_since"
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "zips", :force => true do |t|
    t.string "zip"
    t.string "latitude"
    t.string "longitude"
    t.string "city"
    t.string "state"
  end

  add_index "zips", ["zip"], :name => "index_zips_on_zip"

end
