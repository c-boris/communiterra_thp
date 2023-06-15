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

ActiveRecord::Schema[7.0].define(version: 2023_06_15_100128) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "allotment_users", force: :cascade do |t|
    t.bigint "admin_id", null: false
    t.bigint "member_id", null: false
    t.bigint "allotment_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_allotment_users_on_admin_id"
    t.index ["allotment_id"], name: "index_allotment_users_on_allotment_id"
    t.index ["member_id"], name: "index_allotment_users_on_member_id"
  end

  create_table "allotments", force: :cascade do |t|
    t.integer "size"
    t.string "name"
    t.text "description"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "deliveries", force: :cascade do |t|
    t.string "delivery_type"
    t.float "delivery_price"
    t.string "delivery_provider"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "kept_plants", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "owned_plant_id", null: false
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.string "title"
    t.date "start_date"
    t.date "end_date"
    t.index ["owned_plant_id"], name: "index_kept_plants_on_owned_plant_id"
    t.index ["user_id"], name: "index_kept_plants_on_user_id"
  end

  create_table "listings", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "listing_title"
    t.string "item_name"
    t.text "description"
    t.float "price"
    t.integer "quantity"
    t.bigint "delivery_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["delivery_id"], name: "index_listings_on_delivery_id"
    t.index ["user_id"], name: "index_listings_on_user_id"
  end

  create_table "log_books", force: :cascade do |t|
    t.bigint "owned_plant_id", null: false
    t.datetime "entry_date"
    t.string "title"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "mood"
    t.index ["owned_plant_id"], name: "index_log_books_on_owned_plant_id"
  end

  create_table "owned_plants", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "plant_id", null: false
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nickname"
    t.index ["plant_id"], name: "index_owned_plants_on_plant_id"
    t.index ["user_id"], name: "index_owned_plants_on_user_id"
  end

  create_table "plant_sittings", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "kept_plant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["kept_plant_id"], name: "index_plant_sittings_on_kept_plant_id"
    t.index ["user_id"], name: "index_plant_sittings_on_user_id"
  end

  create_table "plants", force: :cascade do |t|
    t.text "description"
    t.text "common_name"
    t.text "latin_name"
    t.text "specie"
    t.text "vegetation"
    t.text "foliage"
    t.text "mature_height"
    t.text "mature_width"
    t.text "maintenance_level"
    t.text "maintenance_description"
    t.text "water_requirement_level"
    t.text "water_requirement_description"
    t.text "cold_resistance_level"
    t.text "cold_resistance_description"
    t.text "density"
    t.text "exposure_level"
    t.text "exposure_description"
    t.text "flowering"
    t.text "planting"
    t.text "harvest"
    t.text "pruning"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "username"
    t.string "phone_number"
    t.datetime "birthdate"
    t.text "bio"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.boolean "admin", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "allotment_users", "allotments"
  add_foreign_key "allotment_users", "users", column: "admin_id"
  add_foreign_key "allotment_users", "users", column: "member_id"
  add_foreign_key "kept_plants", "owned_plants"
  add_foreign_key "kept_plants", "users"
  add_foreign_key "listings", "deliveries"
  add_foreign_key "listings", "users"
  add_foreign_key "log_books", "owned_plants"
  add_foreign_key "owned_plants", "plants"
  add_foreign_key "owned_plants", "users"
  add_foreign_key "plant_sittings", "kept_plants"
  add_foreign_key "plant_sittings", "users"
end
