# frozen_string_literal: true

class StudentInterestedCourse < ApplicationRecord
  belongs_to :application, foreign_key: 'application_id'
end
