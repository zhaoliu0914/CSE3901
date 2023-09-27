# frozen_string_literal: true

class CreateSectionGraders < ActiveRecord::Migration[7.0]
  def change
    create_table :section_graders do |t|
      t.integer :section_id
      t.string :instructor_name
      t.string :instructor_email
      t.integer :student_id
      t.string :student_name
      t.string :academic_year
      t.string :semester
      t.string :rate
      t.string :comment

      t.timestamps
    end

    add_foreign_key :section_graders, :sections, column: :section_id, primary_key: 'id'
    add_foreign_key :section_graders, :users, column: :student_id, primary_key: 'id'
  end
end
