# frozen_string_literal: true

class Recommendation < ApplicationRecord
  attr_accessor :currentPageNumber

  # foreign key links to users table.
  belongs_to :user, foreign_key: 'instructor_id'
end
