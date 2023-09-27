# frozen_string_literal: true

class StudentSchedulesController < ApplicationController
  def index
    @studentSchedules = StudentSchedule.where(application_id: params[:application_id])
    @application_id = params[:application_id]
  end

  def create
    @studentSchedule = StudentSchedule.new(student_schedule_params)
    @studentSchedule.save

    redirect_to user_application_student_schedules_path
  end

  def update
    @studentSchedule = StudentSchedule.find(params[:id])
    @studentSchedule.update(student_schedule_params)

    redirect_to user_application_student_schedules_path
  end

  def destroy
    @studentSchedule = StudentSchedule.find(params[:id])
    @studentSchedule.destroy

    redirect_to user_application_student_schedules_path
  end

  # private

  def student_schedule_params
    params.require(:student_schedule).permit(:application_id, :schedule_type, :academic_year, :semester,
                                             :course_id, :course_catalog_number, :grade, :availability_day, :start_hour, :end_hour)
  end
end
