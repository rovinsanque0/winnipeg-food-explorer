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

ActiveRecord::Schema[7.2].define(version: 2025_11_07_070034) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "categorizations", force: :cascade do |t|
    t.bigint "restaurant_id", null: false
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_categorizations_on_category_id"
    t.index ["restaurant_id"], name: "index_categorizations_on_restaurant_id"
  end

  create_table "inspections", force: :cascade do |t|
    t.bigint "restaurant_id", null: false
    t.date "inspected_on"
    t.string "outcome"
    t.text "violations"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["restaurant_id"], name: "index_inspections_on_restaurant_id"
  end

  create_table "restaurants", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.bigint "ward_id", null: false
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
    t.string "external_id"
    t.string "phone"
    t.string "postal_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["external_id"], name: "index_restaurants_on_external_id", unique: true
    t.index ["ward_id"], name: "index_restaurants_on_ward_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.bigint "restaurant_id", null: false
    t.integer "rating"
    t.text "comment"
    t.string "author"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["restaurant_id"], name: "index_reviews_on_restaurant_id"
  end

  create_table "wards", force: :cascade do |t|
    t.string "name"
    t.string "external_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["external_id"], name: "index_wards_on_external_id", unique: true
  end

  add_foreign_key "categorizations", "categories"
  add_foreign_key "categorizations", "restaurants"
  add_foreign_key "inspections", "restaurants"
  add_foreign_key "restaurants", "wards"
  add_foreign_key "reviews", "restaurants"
end
