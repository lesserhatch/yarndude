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

ActiveRecord::Schema.define(version: 20170124190235) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "blankets", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.date     "start_date"
    t.date     "end_date"
    t.decimal  "latitude",                      precision: 10, scale: 6
    t.decimal  "longitude",                     precision: 10, scale: 6
    t.datetime "created_at",                                                             null: false
    t.datetime "updated_at",                                                             null: false
    t.string   "timezone"
    t.string   "address"
    t.boolean  "custom_coordinates"
    t.integer  "utc_offset"
    t.string   "slug",               limit: 16
    t.string   "charge_id"
    t.string   "customer_id"
    t.boolean  "example",                                                default: false
    t.boolean  "private",                                                default: false
    t.string   "email_token",        limit: 16
    t.boolean  "email_confirmed",                                        default: false
    t.index ["slug"], name: "index_blankets_on_slug", unique: true, using: :btree
  end

  create_table "days", force: :cascade do |t|
    t.integer  "blanket_id"
    t.integer  "high_temperature"
    t.integer  "low_temperature"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.date     "date"
    t.index ["blanket_id"], name: "index_days_on_blanket_id", using: :btree
  end

  create_table "managers", force: :cascade do |t|
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "palettes", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "temperature_ranges", force: :cascade do |t|
    t.integer  "palette_id"
    t.integer  "yarn_id"
    t.integer  "low_temperature"
    t.integer  "high_temperature"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["palette_id"], name: "index_temperature_ranges_on_palette_id", using: :btree
    t.index ["yarn_id"], name: "index_temperature_ranges_on_yarn_id", using: :btree
  end

  create_table "yarns", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "color",      limit: 6
    t.string   "short_name"
  end

  add_foreign_key "days", "blankets"
  add_foreign_key "temperature_ranges", "palettes"
  add_foreign_key "temperature_ranges", "yarns"
end
