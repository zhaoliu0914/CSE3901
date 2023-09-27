class CreateRecommendations < ActiveRecord::Migration[7.0]
  def change
    create_table :recommendations do |t|
      t.integer :instructor_id, index: true
      t.integer :student_id, null: true
      t.string :student_name
      t.string :student_email
      t.integer :course_id
      t.integer :section_id
      t.string :desc

      t.timestamps
    end

    add_foreign_key :recommendations, :users, column: :instructor_id, primary_key: "id"
    add_foreign_key :recommendations, :users, column: :student_id, primary_key: "id"

  end

end
