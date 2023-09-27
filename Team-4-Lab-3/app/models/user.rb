# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # may has many section_graders
  has_many :section_graders, primary_key: 'id', foreign_key: 'student_id'

  # may has many student_schedules
  has_many :student_schedules, primary_key: 'id', foreign_key: 'student_id'

  # may has many sections
  has_many :sections, primary_key: 'id', foreign_key: 'instructor_id'

  # may has many applications
  has_many :applications, primary_key: 'id', foreign_key: 'student_id'

  # may has many recommendations
  has_many :recommendations, primary_key: 'id', foreign_key: 'instructor_id'
  has_many :recommendations, primary_key: 'id', foreign_key: 'student_id'

  # may has many evaluations
  #has_many :evaluations, primary_key: 'id', foreign_key: 'instructor_id'
  #has_many :evaluations, primary_key: 'id', foreign_key: 'student_id'

  # may has many matchings
  has_many :matchings, primary_key: 'id', foreign_key: 'student_id'

  validates :email, presence: true,
                    format: { with: /[a-z]+\.\d+@osu\.edu*/, message: 'The format of email has to be last.digit@osu.edu' }
  validates :password, presence: true
  validates :role, presence: true
  validates :first_name, presence: true, format: { with: /[a-zA-Z].*/, message: 'The first name should be characters' }
  validates :last_name, presence: true, format: { with: /[a-zA-Z].*/, message: 'The last name should be characters' }

  validates_uniqueness_of :email
end
