class CreateApplications < ActiveRecord::Migration[7.0]
  def change
    create_table :applications do |t|
      t.integer :student_id, index: true
      t.string :email
      t.string :address
      t.string :phone
      t.string :interested_grading

      t.timestamps
    end

    add_foreign_key :applications, :users, column: :student_id, primary_key: "id"

  end
end
