# frozen_string_literal: true

class Application < ApplicationRecord
  attr_accessor :currentPageNumber, :interestedCourses

  # foreign key links to users table.
  belongs_to :user, foreign_key: 'student_id'
  has_many :student_interested_courses, primary_key: 'id', foreign_key: 'application_id', dependent: :delete_all
  has_many :student_schedules, primary_key: 'id', foreign_key: 'application_id', dependent: :delete_all
end
