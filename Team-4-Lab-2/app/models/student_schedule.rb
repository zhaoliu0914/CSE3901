class StudentSchedule < ApplicationRecord

  # foreign key links to users table.
  belongs_to :user, foreign_key: "student_id"
  # foreign key links to courses table.
  belongs_to :course, foreign_key: "course_id"

end
