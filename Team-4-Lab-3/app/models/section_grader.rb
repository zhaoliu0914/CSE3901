# frozen_string_literal: true

class SectionGrader < ApplicationRecord
  attr_accessor :course_catalog_number, :section_class_number, :num_graders_required, :number_graders_assigned, :old_section_id, :currentPageNumber

  # foreign key links to sections table.
  belongs_to :section, foreign_key: 'section_id'
  # foreign key links to users table.
  belongs_to :user, foreign_key: 'student_id'
end
