class CreateSections < ActiveRecord::Migration[7.0]
  def change
    create_table :sections do |t|
      t.integer :course_id, index: true
      t.string :class_number
      t.string :section_number
      t.string :instructor_name
      t.string :instructor_email
      t.string :instruction_mode
      t.date :start_date
      t.date :end_date
      t.string :location
      t.string :room
      t.string :day
      t.string :time
      t.string :is_require_grader

      t.timestamps
    end

    add_foreign_key :sections, :courses, column: :course_id, primary_key: "id"

  end
end
