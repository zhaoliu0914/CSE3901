# frozen_string_literal: true

require 'pagy'

class RecommendationsController < ApplicationController
  def index
    instructorId = current_user.id
    @pagy, @recommendation = pagy(Recommendation.where(instructor_id: instructorId), items: 20)

    return if @recommendation.nil?

    @recommendation.each do |recommendation|
      sectionId = recommendation.section_id
      next if sectionId.nil?

      session = Section.find(sectionId)
      course = Course.find(session.course_id)
      recommendation.section_class_number = session.class_number
      recommendation.course_catalog_number = course.catalog_number
    end
  end

  def new
    @recommendation = Recommendation.new
  end

  def create
    @recommendation = Recommendation.new(recommendation_params)
    if @recommendation.save
      updateCourseSection(@recommendation.id)
      updateStudent(@recommendation.id)
    end

    redirect_to user_recommendations_path page: recommendation_params[:currentPageNumber]
  end

  def update
    @recommendation = Recommendation.find(params[:id])
    @recommendation.update(recommendation_params)

    updateCourseSection(params[:id])
    updateStudent(params[:id])

    redirect_to user_recommendations_path page: recommendation_params[:currentPageNumber]
  end

  def destroy
    @recommendation = Recommendation.find(params[:id])
    @recommendation.destroy

    redirect_to user_recommendations_path page: params[:page]
  end

  def updateCourseSection(recommendationId)
    recommendation = Recommendation.find(recommendationId)
    section = Section.find_by_class_number(recommendation.section_class_number)
    return if section.nil?

    recommendation.update_column(:section_id, section.id)
    recommendation.update_column(:course_id, section.course_id)
  end

  def updateStudent(recommendationId)
    recommendation = Recommendation.find(recommendationId)
    student = User.find_by_email(recommendation.student_email)
    return if student.nil?

    recommendation.update_column(:student_id, student.id)
  end

  def recommendation_params
    params.require(:recommendation).permit(:instructor_id, :course_catalog_number, :section_class_number,
                                           :student_first_name, :student_last_name, :student_email, :desc, :currentPageNumber)
  end
end
