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

ActiveRecord::Schema.define(version: 20170503141859) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "boards", id: :serial, force: :cascade do |t|
    t.string "mac", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.jsonb "metadata", default: {}
    t.string "name", default: ""
    t.datetime "last_active", default: -> { "now()" }
    t.string "type"
    t.jsonb "accepted_links", default: {}
    t.integer "register_status", default: 0
    t.integer "user_id"
    t.string "ip"
    t.string "subtype"
    t.string "image_url"
  end

  create_table "external_data", id: :serial, force: :cascade do |t|
    t.integer "source_type"
    t.jsonb "data"
    t.string "name"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "logs", id: :serial, force: :cascade do |t|
    t.integer "log_type"
    t.string "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sketches", id: :serial, force: :cascade do |t|
    t.jsonb "links", default: [], null: false
    t.jsonb "boards", default: [], null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "published_at"
    t.datetime "trashed_at"
    t.integer "status", default: 0
    t.string "name", default: ""
    t.integer "user_id"
    t.integer "creator_id"
    t.boolean "listed", default: false
    t.string "description", default: ""
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email"
  end

end
