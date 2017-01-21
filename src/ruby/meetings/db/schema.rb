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

ActiveRecord::Schema.define(version: 20161213091029) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "entities", force: :cascade do |t|
    t.string   "name"
    t.string   "wikipedia_entry"
    t.string   "type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "influence_office_people", force: :cascade do |t|
    t.integer  "means_of_influence_id"
    t.integer  "office_id"
    t.integer  "person_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "type"
    t.index ["means_of_influence_id"], name: "index_influence_office_people_on_means_of_influence_id", using: :btree
    t.index ["office_id"], name: "index_influence_office_people_on_office_id", using: :btree
    t.index ["person_id"], name: "index_influence_office_people_on_person_id", using: :btree
  end

  create_table "means_of_influences", force: :cascade do |t|
    t.string   "type"
    t.integer  "day"
    t.integer  "month"
    t.integer  "year"
    t.string   "purpose"
    t.string   "type_of_hospitality"
    t.string   "gift"
    t.integer  "value"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "source_file_id"
    t.integer  "source_file_line_number"
    t.index ["source_file_id"], name: "index_means_of_influences_on_source_file_id", using: :btree
  end

  create_table "source_files", force: :cascade do |t|
    t.string   "location"
    t.string   "uri"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "influence_office_people", "means_of_influences"
  add_foreign_key "means_of_influences", "source_files"
end
