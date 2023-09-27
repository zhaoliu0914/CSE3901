# frozen_string_literal: true

class CreateStudentSchedules < ActiveRecord::Migration[7.0]
  def change
    create_table :student_schedules do |t|
      t.integer :application_id
      # "transcript" for courses have taken in the past, "enrollment" for courses it's taking now, "availableTime" for available Time.
      t.string :schedule_type

      t.string :academic_year
      t.string :semester
      t.integer :course_id
      t.string :course_catalog_number
      # "A", "A-", "B+", "B" etc. for received grade. "pending" for courses it's taking now.
      t.string :grade

      t.string :availability_day
      t.string :start_hour
      t.string :end_hour

      t.timestamps
    end
    add_foreign_key :student_schedules, :applications, column: :application_id, primary_key: 'id'
    # add_foreign_key :student_schedules, :users, column: :student_id, primary_key: "id"
    # add_foreign_key :student_schedules, :courses, column: :course_id, primary_key: "id"
  end
end
