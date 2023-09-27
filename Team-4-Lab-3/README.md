# Rails Project to Manage Student Graders
A web application for managing student graders, created by Team 4 for Lab 3. 

Project Manager: Zhao Liu

Team Members: Anthony Keller, Jason Fong, Deklin Caban, Nicholas Habeth, Dennis Giller
## Table of Contents
* About the Project
* Overview
* Roles
* Setup and installation
  * Requirments
  * Setup Repository
  * Install and configure the database
  * Create the default administrator
  * Initial Administration Setup
 * Tools and Gems
  
## About the Project
### Problem
The Ohio State CSE department hires a large amount of students as graders for a variety of CSE courses. The process in use lacks uniformity. It is based on emails from students and faculty on willingness to work as a grader, the need for graders for a class and recomendations of prospect graders. Our application is designed to address this issue and make a more uniform and efficient system for matching potential graders to the classes/faculty they will grade for. 
### Solution
To solve this we've made a site with an administrator interface (called user index on the site) which office staff can use, and application system that students can use. This application system will allow students to apply to be a grader for certain courses, and administrators will have an interface to assign these graders to courses manually. This database will consist of only CSE courses that are available for a single semester at a time so any applications will have to be for that certain semester. Once moving onto the next semester, the courses and sections tables of the database have to be reset manually to keep the database up to date.
### Assumptions
This website will only allow applications for the 2023-2025 semesters. Because of this, we will only take in graders that have experience in those courses from the 2021-2025 semesters. For example, if the current year is 2024 then students and all users will be assumed to treat the website as if they weren't already in 2025. This means that current course enrollments will be for semesters in 2024, applications will be for semesters in 2024 (unless the current semester is Fall 2024 and they're applying for Spring 2025), and courses taken should only be in years 2021-2024 (2021-2023 if current semester is Spring 2024).

## Overview
Ruby on Rails web app for browsing the course catalog by students, instructors, or administrators. Offers additional functionality for adminstrators.

## Roles
Users can take on one of three roles: Student, Instructor, or Administrator. All roles allow for logging in and browsing the course catalog. In addition to that the Administrators are able to do the following: edit the course catalog which includes adding, deleting and changing courses, reload the catalog, and approve instructor or adminstrator requests.

The following demonstrates the distinct difference in functionality between the 3 types of users:
|                                | Student | Instructor | Administrator |
|--------------------------------|---------|------------|---------------|
| Reset passwords                | &check; | &check;    | &check;       |
| Browse course catalog          | &check; | &check;    | &check;       |
| Create applications for courses| &check; | &cross;    | &check;       |
| Add courses                    | &cross; | &cross;    | &check;       |
| Delete courses                 | &cross; | &cross;    | &check;       |
| Change courses                 | &cross; | &cross;    | &check;       |
| Reload the catalog             | &cross; | &cross;    | &check;       |
| Approve instructor requests    | &cross; | &cross;    | &check;       |
| Approve administrator requests | &cross; | &cross;    | &check;       |
| Create Recommendations         | &cross; | &check;    | &check;       |
| Assign Graders                 | &cross; | &cross;    | &check;       |

-All Users
 -Able to browse the course catalog, and reset their passwords.

-Graders
 -Has the ability to apply to become a grader for CSE courses throughout the Autumn 2023 - Summer 2025 semesters. Each application will be for a corresponding semester and will list all the courses they wish to grade for. That application will allow it's respective user to access a student_schedules page. Each student schedule will correspond to a certain application, in which they can state the times they're available to grade, which courses they're taking, and also what courses they've taken before.
 
-Instructors
 -Has the ability to assign students recommendations. These recommendations can be made and assigned to any student at any time, but they will only link to students that have an account in the database at the time the recommendation is made.
 
-Administrators/Office Staff
 -Have the abilities to assign graders, approve user roles, reload the course database, and modify any courses or sections. The administrator interface will provide links to all users corresponding functions for easy access and support in the decision making process of who should grade what section. 

Approving admin account and instructor account on "User Index" of main page.

# Setup and Installation

### Requirements
On the local machine you want to use, install the following:
* `Ruby 3.2.0`
* `Rails 7.0.4`
* Web-browser for accessing localhost websites (Firefox, Chrome, Edge, and the like)

### Set up the repository
* Clone this repository on to your local machine (`git clone` followed by the repositories URL)
* If you are missing required gems you may need to run <$ bundle install>

### Install and configure the database

In your local repository directory:

`rails db:create`

`rails db:migrate`

`rails db:seed`

To start running the server:

`rails s`

To access the server:

Navigate to `localhost:3000` in your web browser

### Create the default administrator

email = `admin.1@osu.edu`

password = `admin.1`

### Initial Administration Setup

The seed administrator would need approve and reject upcoming instructors and admin. Approved administrators would need to go into the course index and reload the database to populate it. 
- Possible parameters for reloading the courses and sections tables.
  - Campus:
    - "col" for Columbus, "wst" for Wooster, "mns" for Mansfield, "mrn" for Marion, "nwk" for Newark, "lma" for Lima
  - Semester:
    - Semester numbers increment in values of 2. Current Semester "Spring 2023" has corresponding term number "1232", "Summer 2023" has corresponding term number "1234", "Autumn 2023" - "1236", "Spring 2024" - "1238", etc. 



## Tools and Gems
* Ruby 3.2.0
* Ruby on Rails
* Pre-Installed Gems
* HTTParty Gem
* Devise Gem
* Pagy Gem
* Bootstrap Gem



