# frozen_string_literal: true

require 'pagy'

class EvaluationsController < ApplicationController

  def index
    if current_user.role == "instructor"
      @pagy, @sectionGraders = pagy(SectionGrader.where(instructor_email: current_user.email), items: 20)
    elsif current_user.role == 'student'
      @pagy, @sectionGraders = pagy(SectionGrader.where(student_id: current_user.id), items: 20)
    else
      @pagy, @sectionGraders = pagy(SectionGrader.all, items: 20)
    end

    return if @sectionGraders.nil?

    @sectionGraders.each do |sectionGrader|
      sectionId = sectionGrader.section_id
      next if sectionId.nil?

      section = Section.find(sectionId)
      course = Course.find(section.course_id)
      sectionGrader.course_catalog_number = course.catalog_number
      sectionGrader.section_class_number = section.class_number
    end
  end

  def update
    section_grader = SectionGrader.find(params[:id])
    section_grader.update_column(:rate, section_grader_params[:rate])
    section_grader.update_column(:comment, section_grader_params[:comment])

    redirect_to user_evaluations_path
  end


  def section_grader_params
    params.require(:section_grader).permit(:section_id, :student_id, :academic_year, :semester, :old_section_id, :rate, :comment)
  end
end
