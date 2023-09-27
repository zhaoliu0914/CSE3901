# frozen_string_literal: true

class CreateStudentInterestedCourses < ActiveRecord::Migration[7.0]
  def change
    create_table :student_interested_courses do |t|
      t.integer :application_id
      t.string :course_id
      t.string :course_catalog_number

      t.timestamps
    end

    add_foreign_key :student_interested_courses, :applications, column: :application_id, primary_key: 'id'
  end
end
