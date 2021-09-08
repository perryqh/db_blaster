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

ActiveRecord::Schema.define(version: 2021_09_08_214439) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "db_blaster_source_tables", force: :cascade do |t|
    t.string "name", null: false
    t.text "ignored_columns", default: [], array: true
    t.datetime "last_published_updated_at"
    t.integer "batch_size", default: 100
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "last_published_id", default: "0"
  end

  create_table "mountains", force: :cascade do |t|
    t.string "name"
    t.integer "height"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "verbose_description"
  end

  create_table "trails", force: :cascade do |t|
    t.string "name"
    t.integer "distance"
    t.string "phone_number"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
