# frozen_string_literal: true

require 'pagy'

class AssignmentsController < ApplicationController
  def index
    @pagy, @sectionGraders = pagy(SectionGrader.order(section_id: :asc), items: 20)

    return if @sectionGraders.nil?

    @sectionGraders.each do |sectionGrader|
      sectionId = sectionGrader.section_id
      next if sectionId.nil?

      section = Section.find(sectionId)
      course = Course.find(section.course_id)
      sectionGrader.course_catalog_number = course.catalog_number
      sectionGrader.section_class_number = section.class_number
      sectionGrader.num_graders_required = section.num_graders_required
      sectionGrader.number_graders_assigned = section.number_graders_assigned
    end
  end

  def unassigned_section
    @sections = Section.find_by_sql("select section.* from sections section inner join courses course on course.id = section.course_id where section.num_graders_required - section.number_graders_assigned >= 1 order by course.catalog_number asc")

    return if @sections.nil?

    @sections.each do |session|
      course = Course.find(session.course_id)
      session.courseCatalogNumber = course.catalog_number
    end

  end

  def new
    @sectionGrader = SectionGrader.new

    @sections = Section.order(class_number: :asc)
    @sections&.each do |section|
      course = Course.find(section.course_id)
      section.courseCatalogNumber = course.catalog_number
    end

    @users = User.order(first_name: :asc).where(role: 'student')
  end

  def create
    @sectionGrader = SectionGrader.new(section_grader_params)

    if @sectionGrader.save
      section = Section.find(section_grader_params[:section_id])
      student = User.find(section_grader_params[:student_id])

      @sectionGrader.update_column(:instructor_name, section.instructor_name)
      @sectionGrader.update_column(:instructor_email, section.instructor_email)

      @sectionGrader.update_column(:student_name, student.first_name + " " + student.last_name)

      section.update_column(:number_graders_assigned, section.number_graders_assigned + 1)
    end

    redirect_to assignments_path
  end

  def edit
    @sectionGrader = SectionGrader.find(params[:id])

    @sections = Section.order(class_number: :asc)
    @sections&.each do |section|
      course = Course.find(section.course_id)
      section.courseCatalogNumber = course.catalog_number
    end

    @users = User.order(first_name: :asc).where(role: 'student')
  end

  def update
    @sectionGrader = SectionGrader.find(params[:id])
    if @sectionGrader.update(section_grader_params)
      newSectionId = section_grader_params[:section_id]
      oldSectionId = section_grader_params[:old_section_id]

      if newSectionId == oldSectionId
        student = User.find(section_grader_params[:student_id])
        @sectionGrader.update_column(:student_name, student.first_name + " " + student.last_name)

      else
        newSection = Section.find(newSectionId)

        @sectionGrader.update_column(:instructor_name, newSection.instructor_name)
        @sectionGrader.update_column(:instructor_email, newSection.instructor_email)

        newSection.update_column(:number_graders_assigned, newSection.number_graders_assigned + 1)

        oldSection = Section.find(oldSectionId)
        oldNumberAssignedGraders = oldSection.number_graders_assigned
        if oldNumberAssignedGraders > 0
          oldSection.update_column(:number_graders_assigned, oldNumberAssignedGraders - 1)
        end
      end
    end

    redirect_to assignments_path
  end

  def destroy
    @sectionGrader = SectionGrader.find(params[:id])
    sectionId = @sectionGrader.section_id
    @sectionGrader.destroy

    section = Section.find(sectionId)
    numberAssignedGraders = section.number_graders_assigned
    if numberAssignedGraders > 0
      section.update_column(:number_graders_assigned, numberAssignedGraders - 1)
    end

    redirect_to assignments_path
  end

  def section_grader_params
    params.require(:section_grader).permit(:section_id, :student_id, :academic_year, :semester, :old_section_id)
  end
end
