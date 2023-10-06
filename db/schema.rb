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

ActiveRecord::Schema[7.0].define(version: 2023_10_06_145045) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "personal_informations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "address"
    t.string "emergency_contact_number"
    t.integer "emergency_contact_relationship"
    t.text "health_issues"
    t.text "medication_during_event"
    t.text "psychological_features"
    t.text "diet"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_personal_informations_on_user_id"
  end

  create_table "rank_histories", force: :cascade do |t|
    t.integer "rank", null: false
    t.bigint "user_id", null: false
    t.boolean "current", default: true, null: false
    t.date "date_begin", null: false
    t.date "date_of_oath"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_rank_histories_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "surname", null: false
    t.integer "rank", null: false
    t.boolean "promise", null: false
    t.string "phone"
    t.string "email"
    t.integer "activity_statuss", null: false
    t.decimal "membership_fee_bilance", default: "0.0", null: false
    t.date "joined_date", null: false
    t.date "birth_date"
    t.integer "sex"
    t.string "password_digest"
    t.integer "permission_level", default: 0, null: false
    t.boolean "agreed_to_data_collection"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "personal_informations", "users"
  add_foreign_key "rank_histories", "users"
end
