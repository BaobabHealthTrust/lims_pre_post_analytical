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

ActiveRecord::Schema.define(version: 20170926190658) do

  create_table "roles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "special_roles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "user_id"
    t.string "role_id"
    t.string "given_role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "target_labs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "name"
    t.string "district_id"
    t.string "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "undispatched_samples", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "tracking_number"
    t.string "date_drawn"
    t.string "patient_id"
    t.string "patient_name"
    t.string "sex"
    t.string "sample_type"
    t.string "target_lab"
    t.string "order_location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "undrawn_samples", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "tracking_number"
    t.string "sample_type"
    t.string "patient_id"
    t.string "patient_name"
    t.string "patient_gender"
    t.string "date_of_birth"
    t.string "date_requested"
    t.string "order_location"
    t.string "requested_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_type_roles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "user_type_id"
    t.string "role_id"
    t.string "given_role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_types", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "staff_id"
    t.string "name"
    t.string "sex"
    t.string "username"
    t.string "password"
    t.string "email"
    t.string "phoneNumber"
    t.string "user_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_types_id"
    t.index ["user_types_id"], name: "index_users_on_user_types_id"
  end

  create_table "wards", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "name"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "users", "user_types", column: "user_types_id"
end
