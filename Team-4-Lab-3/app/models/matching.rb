# frozen_string_literal: true

class Matching < ApplicationRecord
  # foreign key links to sections table.
  belongs_to :section, foreign_key: 'section_id'
  # foreign key links to users table.
  belongs_to :user, foreign_key: 'student_id'
end
