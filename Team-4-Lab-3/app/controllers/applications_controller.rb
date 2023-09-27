# frozen_string_literal: true

require 'pagy'

class ApplicationsController < ApplicationController
  before_action :admin_or_student?

  def show
    if current_user.role == 'admin'
      @pagy, @applications = pagy(Application.all, items: 20)
    elsif current_user.role == 'student'
      studentId = params[:id]
      @pagy, @applications = pagy(Application.where(student_id: studentId), items: 20)
    end
  end

  def index
    if current_user.role == 'admin'
      @pagy, @applications = pagy(Application.all, items: 20)
    elsif current_user.role == 'student'
      studentId = current_user.id
      @pagy, @applications = pagy(Application.where(student_id: studentId), items: 20)
    end
  end

  def create
    @application = Application.new(application_params)
    updateStudentInterestedCourses(@application.id, application_params[:interestedCourses]) if @application.save

    redirect_to user_applications_path page: application_params[:currentPageNumber]
  end

  def update
    @application = Application.find(params[:id])
    @application.update(application_params)

    updateStudentInterestedCourses(params[:id], application_params[:interestedCourses])

    redirect_to user_applications_path page: application_params[:currentPageNumber]
  end

  def destroy
    @application = Application.find(params[:id])
    @application.destroy

    redirect_to user_applications_path page: params[:page]
  end

  def updateStudentInterestedCourses(application_id, interestedCourses)
    StudentInterestedCourse.delete_by(application_id:)

    interestedCourses.each do |course|
      next unless !course.nil? && !course.blank?

      newInterestCourse = StudentInterestedCourse.new
      newInterestCourse.application_id = application_id
      newInterestCourse.course_catalog_number = course
      newInterestCourse.save
    end
  end

  def application_params
    params.require(:application).permit(:student_id, :academic_year, :semester, :phone, :address,
                                        :currentPageNumber, interestedCourses: [])
  end
end
