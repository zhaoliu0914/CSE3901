class Application < ApplicationRecord

  # foreign key links to users table.
  belongs_to :user, foreign_key: "student_id"

end
