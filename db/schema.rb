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

ActiveRecord::Schema.define(version: 20150629032727) do

  create_table "artist_videos", force: :cascade do |t|
    t.integer  "artist_id"
    t.integer  "video_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "artists", force: :cascade do |t|
    t.string   "name"
    t.string   "gender"
    t.string   "wiki_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "collections", force: :cascade do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "collections_videos", force: :cascade do |t|
    t.integer  "collection_id"
    t.integer  "video_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "likes", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "video_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "likes", ["user_id", "video_id"], name: "index_likes_on_user_id_and_video_id", unique: true

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.boolean  "admin",                  default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "videos", force: :cascade do |t|
    t.string   "youtube_id"
    t.string   "thumbnail"
    t.string   "artist"
    t.string   "title_korean"
    t.string   "title_english"
    t.string   "youtube_user_id"
    t.text     "description"
    t.integer  "hotness",                      default: 0
    t.integer  "cheesiness",                   default: 0
    t.integer  "english_percentage",           default: 0
    t.boolean  "english_subtitle",             default: false
    t.boolean  "official",                     default: false
    t.boolean  "licensed_content",             default: false
    t.integer  "youtube_views",      limit: 8
    t.string   "definition"
    t.integer  "duration"
    t.string   "dimension"
    t.boolean  "caption",                      default: false
    t.string   "category"
    t.date     "upload_date"
    t.decimal  "approval_rating",              default: 0.0
    t.integer  "upvotes_per_views",            default: 0
    t.integer  "likes",                        default: 0
    t.integer  "upvotes",            limit: 8
    t.integer  "downvotes",          limit: 8
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
  end

end
