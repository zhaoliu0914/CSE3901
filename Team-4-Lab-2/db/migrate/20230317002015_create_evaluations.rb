class CreateEvaluations < ActiveRecord::Migration[7.0]
  def change
    create_table :evaluations do |t|
      t.integer :instructor_id
      t.integer :student_id
      t.integer :section_id
      t.string :evaluation

      t.timestamps
    end

    add_foreign_key :evaluations, :users, column: :instructor_id, primary_key: "id"
    add_foreign_key :evaluations, :users, column: :student_id, primary_key: "id"
    add_foreign_key :evaluations, :sections, column: :section_id, primary_key: "id"

  end
end
