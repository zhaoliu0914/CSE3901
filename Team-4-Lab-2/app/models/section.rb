class Section < ApplicationRecord

  # foreign key links to courses table.
  belongs_to :course, foreign_key: "course_id"

  # may has many student_schedules
  has_many :section_graders, primary_key: "id", foreign_key: "section_id"

  # may has many matchings
  has_many :matchings, primary_key: "id", foreign_key: "section_id"

  default_scope{ order(class_number: :asc) }
  
end
