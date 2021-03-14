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

ActiveRecord::Schema.define(version: 20210314091747) do

  create_table "attendances", force: :cascade do |t|
    t.date "worked_on"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.string "note"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "finish_overtime"
    t.integer "next_day"
    t.string "operation"
    t.string "superior_marking"
    t.integer "request_status", default: 0
    t.integer "chg"
    t.string "superior_mark1"
    t.string "superior_mark2"
    t.datetime "end_time"
    t.integer "superior_status1", default: 0
    t.integer "superior_status2", default: 0
    t.integer "out_of_time"
    t.integer "chg1"
    t.integer "chg2"
    t.integer "next_day1"
    t.index ["user_id"], name: "index_attendances_on_user_id"
  end

  create_table "logs", force: :cascade do |t|
    t.datetime "started_bfr"
    t.datetime "finished_bfr"
    t.datetime "started_aft"
    t.datetime "finished_aft"
    t.date "approval_day"
    t.integer "attendance_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "worked_on"
    t.index ["attendance_id"], name: "index_logs_on_attendance_id"
  end

  create_table "sites", force: :cascade do |t|
    t.integer "site_number"
    t.string "site_name"
    t.string "site_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.string "affiliation"
    t.datetime "basic_time", default: "2021-03-13 23:00:00"
    t.datetime "work_time", default: "2021-03-13 22:30:00"
    t.integer "employee_number"
    t.string "uid"
    t.datetime "designated_work_start_time"
    t.datetime "designated_work_end_time"
    t.boolean "superior"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
