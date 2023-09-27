# frozen_string_literal: true

class Course < ApplicationRecord
  attr_accessor :currentPageNumber

  # may has many sections
  has_many :sections, primary_key: 'id', foreign_key: 'course_id', dependent: :delete_all

  # may has many student_schedules
  # has_many :student_schedules, primary_key: "id", foreign_key: "course_id"
end
