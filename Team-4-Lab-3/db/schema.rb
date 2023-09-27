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

ActiveRecord::Schema[7.0].define(version: 2023_04_23_071456) do
  create_table "applications", force: :cascade do |t|
    t.integer "student_id"
    t.string "academic_year"
    t.string "semester"
    t.string "phone"
    t.string "address"
    t.string "interested_grading"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["student_id"], name: "index_applications_on_student_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "catalog_number"
    t.string "title"
    t.string "short_description"
    t.string "description"
    t.string "campus"
    t.string "term"
    t.integer "units"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["catalog_number"], name: "index_courses_on_catalog_number"
  end

  create_table "matchings", force: :cascade do |t|
    t.integer "section_id"
    t.integer "student_id"
    t.string "semester"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "recommendations", force: :cascade do |t|
    t.integer "instructor_id"
    t.integer "course_id"
    t.integer "section_id"
    t.string "course_catalog_number"
    t.string "section_class_number"
    t.integer "student_id"
    t.string "student_first_name"
    t.string "student_last_name"
    t.string "student_email"
    t.string "desc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["instructor_id"], name: "index_recommendations_on_instructor_id"
  end

  create_table "section_graders", force: :cascade do |t|
    t.integer "section_id"
    t.string "instructor_name"
    t.string "instructor_email"
    t.integer "student_id"
    t.string "student_name"
    t.string "academic_year"
    t.string "semester"
    t.string "rate"
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sections", force: :cascade do |t|
    t.integer "course_id"
    t.string "class_number"
    t.string "section_number"
    t.string "instructor_name"
    t.string "instructor_email"
    t.string "instruction_mode"
    t.date "start_date"
    t.date "end_date"
    t.string "location"
    t.string "room"
    t.string "day"
    t.string "time"
    t.string "is_require_grader"
    t.integer "num_graders_required", default: 1, null: false
    t.integer "number_graders_assigned", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_sections_on_course_id"
  end

  create_table "student_interested_courses", force: :cascade do |t|
    t.integer "application_id"
    t.string "course_id"
    t.string "course_catalog_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "student_schedules", force: :cascade do |t|
    t.integer "application_id"
    t.string "schedule_type"
    t.string "academic_year"
    t.string "semester"
    t.integer "course_id"
    t.string "course_catalog_number"
    t.string "grade"
    t.string "availability_day"
    t.string "start_hour"
    t.string "end_hour"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "role", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "applications", "users", column: "student_id"
  add_foreign_key "matchings", "sections"
  add_foreign_key "matchings", "users", column: "student_id"
  add_foreign_key "recommendations", "users", column: "instructor_id"
  add_foreign_key "recommendations", "users", column: "student_id"
  add_foreign_key "section_graders", "sections"
  add_foreign_key "section_graders", "users", column: "student_id"
  add_foreign_key "sections", "courses"
  add_foreign_key "student_interested_courses", "applications"
  add_foreign_key "student_schedules", "applications"
end
