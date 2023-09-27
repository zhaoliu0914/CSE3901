# frozen_string_literal: true

class CreateMatchings < ActiveRecord::Migration[7.0]
  def change
    create_table :matchings do |t|
      t.integer :section_id
      t.integer :student_id
      t.string :semester

      t.timestamps
    end

    add_foreign_key :matchings, :users, column: :student_id, primary_key: 'id'
    add_foreign_key :matchings, :sections, column: :section_id, primary_key: 'id'
  end
end
