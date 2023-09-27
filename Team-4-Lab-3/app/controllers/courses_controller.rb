# frozen_string_literal: true

require 'httparty'
require 'pagy'

class CoursesController < ApplicationController
  before_action :admin?, only: %i[reload_new destroy update create new edit]

  def show
    redirect_to courses_reload_new_path
  end

  def index
    if params[:order].nil? || (params[:order] == '') || (params[:order] == 'asc')
      @pagy, @course = pagy(Course.order(catalog_number: :asc), items: 1)
      @order = 'asc'
    else
      @pagy, @course = pagy(Course.order(catalog_number: :desc), items: 1)
      @order = 'desc'
    end
  end

  def reload_new; end

  def reload
    # Create HTTP API "Get" request and parse JSON response
    api_url = 'https://content.osu.edu/v2/classes/search?q=cse&client=class-search-ui'
    api_url += "&campus=#{params[:campus]}" if !params[:campus].nil? && (params[:campus] != '')
    api_url += "&term=#{params[:semester]}" if !params[:semester].nil? && (params[:semester] != '')
    # api = HTTParty.get("https://content.osu.edu/v2/classes/search?q=cse&client=class-search-ui&campus=col&term=1234")
    api = HTTParty.get(api_url)
    JSON.parse(api.body)

    # Section.destroy(Section.ids)
    Course.destroy(Course.ids)

    result = api['data']['courses']
    # Loop through to get all the values for the course and section table
    result.each do |courseData|
      # Gets the course detail
      # Creates a row for the Course
      @course = Course.create(
        catalog_number: courseData['course']['catalogNumber'],
        title: courseData['course']['title'],
        short_description: courseData['course']['shortDescription'],
        description: courseData['course']['description'],
        campus: courseData['course']['campus'],
        term: courseData['course']['term'],
        units: courseData['course']['maxUnits']
      )
      # puts courseDetail
      courseData['sections'].each do |sectionData|
        # Gets the section detail of the course
        # Create a row for the Section
        @course.sections.create(
          # instructor_id: sectionDetail[1], <= This is still undecided
          class_number: sectionData['classNumber'],
          section_number: sectionData['section'],
          instructor_name: sectionData['meetings'][0]['instructors'][0]['displayName'],
          instructor_email: sectionData['meetings'][0]['instructors'][0]['email'],
          instruction_mode: sectionData['instructionMode'],
          start_date: sectionData['startDate'],
          end_date: sectionData['endDate'],
          location: sectionData['location'],
          room: sectionData['meetings'][0]['facilityDescriptionShort'],
          day: checkDays(sectionData),
          time: totalTime(sectionData),
          is_require_grader: 'yes'
        )
      end
    end

    redirect_to courses_path
  end

  def new
    @course = Course.new
  end

  def create
    @course = Course.new(course_params)
    if @course.save
      redirect_to courses_path
    else
      render :new
    end
  end

  def edit
    @course = Course.find(params[:id])
  end

  def update
    @course = Course.find(params[:id])
    @course.update(course_params)

    redirect_to courses_path page: course_params[:currentPageNumber]
  end

  def destroy
    @course = Course.find(params[:id])
    @course.sections.each(&:destroy)
    @course.destroy
    redirect_to courses_path
  end

  private

  # Fetch the email data from courseData
  def getEmail(section)
    meetings = section['meetings']
    email = meetings[0]['instructors'][0]['email']
  end

  # Concatenates the facility room and room number.
  def facRoom(section)
    meetings = section['meetings']
    facilityDescriptionShort = meetings[0]['facilityDescriptionShort']
    room = meetings[0]['room']
    roomLoc = if facilityDescriptionShort && room
                "#{facilityDescriptionShort} #{room}"
              else
                # If the value for room is unknown, the class will be online
                'ONLINE'
              end
  end

  # Checks for which day will the class held on
  def checkDays(section)
    meetings = section['meetings']
    days = ''
    days += 'Monday, ' if meetings[0]['monday'] == true
    days += 'Tuesday, ' if meetings[0]['tuesday'] == true
    days += 'Wednesday, ' if meetings[0]['wednesday'] == true
    days += 'Thursday, ' if meetings[0]['thursday'] == true
    days += 'Friday, ' if meetings[0]['friday'] == true
    days += 'Saturday, ' if meetings[0]['saturday'] == true
    return unless meetings[0]['sunday'] == true

    days += 'Sunday, '
  end

  # Concatenates the start of class time to end of class
  def totalTime(section)
    meetings = section['meetings']
    startTime = meetings[0]['startTime']
    endTime = meetings[0]['endTime']
    time = if startTime && endTime
             "#{startTime} - #{endTime}"
           else
             # Classes startTime and endTime may be null sometimes
             'To Be Determined'
           end
  end

  def course_params
    params.require(:course).permit(:catalog_number, :title, :short_description, :description, :campus, :term, :units,
                                   :currentPageNumber)
  end
end
