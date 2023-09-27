# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :admin?

  ## displays all sections using pagy to split up the sections on different pages
  ## displays all the users on left side of the screen

  def index
    @users = User.all
    @sections = Section.all
    @pagy, @sections = pagy(@sections)
  end

  def show
    redirect_to users_approval_path
  end

  ## when applying to be an administrator another administrator must approve this code updates a waiting admin or instructor

  def approval_update
    @user = User.find(params[:id])
    if @user.role == 'admin_waiting'
      @user.update_column(:role, 'admin')
    elsif @user.role == 'instructor_waiting'
      @user.update_column(:role, 'instructor')
    end
    redirect_to users_path
  end
end
