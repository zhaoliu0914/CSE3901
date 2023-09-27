class Recommendation < ApplicationRecord

  # foreign key links to users table.
  belongs_to :user, foreign_key: "instructor_id"
  belongs_to :user, foreign_key: "student_id"

end
