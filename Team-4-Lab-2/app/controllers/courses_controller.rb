require 'httparty'
require 'pagy'

class CoursesController < ApplicationController

  def show
    redirect_to courses_reload_new_path
  end

  def index

    if params[:order] == nil or params[:order] == "" or params[:order] == "asc"
      @pagy, @course = pagy(Course.order(catalog_number: :asc), items: 1)
      @order = "asc"
    else
      @pagy, @course = pagy(Course.order(catalog_number: :desc), items: 1)
      @order = "desc"
    end

  end

  def reload_new
    if current_user.role != "admin"
      redirect_to root_path
    end
  end

  def reload
    if current_user.role == "admin"
      # Create HTTP API "Get" request and parse JSON response
      api_url = "https://content.osu.edu/v2/classes/search?q=cse&client=class-search-ui"
      if params[:campus] != nil and params[:campus] != ""
        api_url += "&campus=" + params[:campus]
      end
      if params[:semester] != nil and params[:semester] != ""
        api_url += "&term=" + params[:semester]
      end
      #api = HTTParty.get("https://content.osu.edu/v2/classes/search?q=cse&client=class-search-ui&campus=col&term=1234")
      api = HTTParty.get(api_url)
      JSON.parse(api.body)

      #Section.destroy(Section.ids)
      Course.destroy(Course.ids)

      result = api["data"]["courses"]
      # Loop through to get all the values for the course and section table
      result.each do |courseData|
        # Gets the course detail
        # Creates a row for the Course
        @course = Course.create(
          catalog_number: courseData["course"]["catalogNumber"],
          title: courseData["course"]["title"],
          short_description: courseData["course"]["shortDescription"],
          description: courseData["course"]["description"],
          campus: courseData["course"]["campus"],
          term: courseData["course"]["term"],
          units: courseData["course"]["maxUnits"]
        )
        # puts courseDetail
        courseData["sections"].each do |sectionData|
          # Gets the section detail of the course
          # Create a row for the Section
          @course.sections.create(
            #instructor_id: sectionDetail[1], <= This is still undecided
            class_number: sectionData["classNumber"],
            section_number: sectionData["section"],
            instructor_name: sectionData["meetings"][0]["instructors"][0]["displayName"],
            instructor_email: sectionData["meetings"][0]["instructors"][0]["email"],
            instruction_mode: sectionData["instructionMode"],
            start_date: sectionData["startDate"],
            end_date: sectionData["endDate"],
            location: sectionData["location"],
            room: sectionData["meetings"][0]["facilityDescriptionShort"],
            day: checkDays(sectionData),
            time: totalTime(sectionData)
          )
          # puts sectionDetail
        end

        #@course.save

      end
    end

    redirect_to courses_path

  end

  def new
    if current_user.role == "admin"
      @course = Course.new
    end
  end

  def create
    if current_user.role == "admin"
      @course = Course.new(course_params)
      if @course.save
        redirect_to courses_path
      else
        render :new
      end
    end
  end
  
  #Fetch the email data from courseData
  def getEmail(section)
    meetings = section["meetings"]
    email = meetings[0]["instructors"][0]["email"]
    return email
  end

  #Concatenates the facility room and room number.
  def facRoom(section)
    meetings = section["meetings"]
    facilityDescriptionShort = meetings[0]["facilityDescriptionShort"]
    room = meetings[0]["room"]
    if facilityDescriptionShort && room
      roomLoc = facilityDescriptionShort + " " + room
    else
      #If the value for room is unknown, the class will be online
      roomLoc = "ONLINE"
    end 
    return roomLoc
  end

  #Checks for which day will the class held on
  def checkDays(section)
    meetings = section["meetings"]
    days=""
    if meetings[0]["monday"] == true
      days = days + "Monday, "
    end
    if meetings[0]["tuesday"] == true
      days = days + "Tuesday, "
    end
    if meetings[0]["wednesday"] == true
      days = days + "Wednesday, "
    end
    if meetings[0]["thursday"] == true
      days = days + "Thursday, "
    end
    if meetings[0]["friday"] == true
      days = days + "Friday, "
    end
    if meetings[0]["saturday"] == true
      days = days + "Saturday, "
    end
    if meetings[0]["sunday"] == true
      days = days + "Sunday, "
    end
    return days
  end

  #Concatenates the start of class time to end of class
  def totalTime(section)
    meetings = section["meetings"]
    startTime = meetings[0]["startTime"]
    endTime = meetings[0]["endTime"]
    if startTime && endTime
      time = startTime + " - " + endTime
    else
      #Classes startTime and endTime may be null sometimes
      time = nil
    end
    return time
  end

  def edit
    if current_user.role == "admin"
      @course = Course.find(params[:id])
    end
  end

  
  def update
    if current_user.role == "admin"
      @course = Course.find(params[:id])
      if @course.update(course_params)
        redirect_to courses_path
      else
        render :edit
      end
    else 
      redirect_to courses_path
    end
  end

  def destroy
    @course = Course.find(params[:id])
    @course.sections.each do |section|
      section.destroy
    end
    @course.destroy
    redirect_to courses_path
  end

  private

  def course_params
    params.require(:course).permit(:catalog_number, :title, :short_description, :description, :campus, :term, :units)
  end
end
