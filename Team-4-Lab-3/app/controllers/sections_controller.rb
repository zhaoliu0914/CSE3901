# frozen_string_literal: true

class SectionsController < ApplicationController
  before_action :admin?

  def new
    @section = Section.new
  end

  def create
    @course = Course.find(params[:course_id])
    @section = @course.sections.new(section_params)
    if @section.save
      update_num_graders_required(@section)
    end

    redirect_to courses_path page: section_params[:currentPageNumber]
  end

  def edit
    @section = Section.find(params[:id])
  end

  def update
    @section = Section.find(params[:id])
    if @section.update(section_params)
      update_num_graders_required(@section)
    end

    redirect_back fallback_location: root_path
  end

  def destroy
    @section = Section.find(params[:id])
    @section.destroy

    redirect_to courses_path page: params[:page]
  end

  def update_num_graders_required(section)
    if section.is_require_grader == "no"
      section.update_column(:num_graders_required, 0)
    elsif section.is_require_grader == "yes" and section.num_graders_required < 1
      section.update_column(:num_graders_required, 1)
    end
  end

  private

  def section_params
    params.require(:section).permit(:course_id, :class_number, :section_number, :instructor_name, :instructor_email,
                                    :instruction_mode, :start_date, :end_date, :location, :room, :day, :time, :is_require_grader, :currentPageNumber, :num_graders_required)
  end
end
