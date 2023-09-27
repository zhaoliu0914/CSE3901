class SectionsController < ApplicationController

  
  def new
    if current_user.role == "admin"
      @section = Section.new
    else 
      redirect_to courses_path
    end
  end

  def create
    @course = Course.find(params[:course_id])
    if current_user.role == "admin"
      @section = @course.sections.new(section_params)
      if @section.save
        redirect_to courses_path
      else
        render :new
      end
    else
      redirect_to courses_path
    end
  end

  def edit
    if current_user.role == "admin"
        @section = Section.find(params[:id])
    else
        redirect_to courses_path
    end
  end
  
  def update
    if current_user.role == "admin"
        @section = Section.find(params[:id])
        if @section.update(section_params)
            redirect_to courses_path
        else
            render :edit
        end
    else
        redirect_to courses_path
    end
  end

  def destroy
    if(current_user.role == "admin")
        @section = Section.find(params[:id])
        @section.destroy
    end
    redirect_to courses_path
  end
  
  private

  def section_params
    params.require(:section).permit(:course_id, :class_number, :section_number, :instructor_name, :instructor_email, :instruction_mode, :start_date, :end_date, :location, :room, :day, :time, :is_require_grader)
  end
end