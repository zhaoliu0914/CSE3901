# frozen_string_literal: true

class CreateCourses < ActiveRecord::Migration[7.0]
  def change
    create_table :courses do |t|
      t.string :catalog_number, index: true
      t.string :title
      t.string :short_description
      t.string :description
      t.string :campus
      t.string :term
      t.integer :units

      t.timestamps
    end
  end
end
