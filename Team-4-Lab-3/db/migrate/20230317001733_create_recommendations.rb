# frozen_string_literal: true

class CreateRecommendations < ActiveRecord::Migration[7.0]
  def change
    create_table :recommendations do |t|
      t.integer :instructor_id, index: true
      t.integer :course_id, null: true
      t.integer :section_id, null: true
      t.string :course_catalog_number
      t.string :section_class_number
      t.integer :student_id, null: true
      t.string :student_first_name
      t.string :student_last_name
      t.string :student_email
      t.string :desc

      t.timestamps
    end

    add_foreign_key :recommendations, :users, column: :instructor_id, primary_key: 'id'
    add_foreign_key :recommendations, :users, column: :student_id, primary_key: 'id'
  end
end
