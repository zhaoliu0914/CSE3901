class CreateStudentSchedules < ActiveRecord::Migration[7.0]
  def change
    create_table :student_schedules do |t|
      t.integer :student_id
      t.string :semester
      t.string :schedule_type
      t.string :course_id
      t.date :availability_date
      t.string :availability_time

      t.timestamps
    end

    add_foreign_key :student_schedules, :users, column: :student_id, primary_key: "id"
    add_foreign_key :student_schedules, :courses, column: :course_id, primary_key: "id"

  end
end
