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

ActiveRecord::Schema[8.1].define(version: 2025_12_07_144416) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "amenities", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "apartments", force: :cascade do |t|
    t.string "amenities_flag", default: [], array: true
    t.boolean "approved", default: false
    t.string "block", null: false
    t.datetime "created_at", null: false
    t.string "floor"
    t.integer "number", null: false
    t.datetime "updated_at", null: false
  end

  create_table "entry_logs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "in_time"
    t.datetime "out_time"
    t.uuid "rfid", null: false
    t.datetime "updated_at", null: false
  end

  create_table "invoices", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "due_date"
    t.datetime "fulfillment_date"
    t.integer "paid_amount", default: 0
    t.string "status", default: "pending"
    t.integer "total_amount", null: false
    t.uuid "transaction_id"
    t.datetime "updated_at", null: false
  end

  create_table "requests", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "description", null: false
    t.datetime "eta"
    t.integer "instance_id"
    t.string "reference_number", null: false
    t.integer "request_type", default: 0, null: false
    t.string "status", default: "pending", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "name", null: false
    t.uuid "r_rfid"
    t.string "role", default: "resident"
    t.datetime "updated_at", null: false
  end

  create_table "vendors", force: :cascade do |t|
    t.bigint "amenity_id"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.string "phone_number"
    t.datetime "updated_at", null: false
    t.uuid "v_rfid"
    t.index ["amenity_id"], name: "index_vendors_on_amenity_id"
  end

  add_foreign_key "vendors", "amenities"
end
