# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pagy::Backend
  before_action :authenticate_user!

  def admin?
    redirect_to root_path unless current_user.role == 'admin'
  end

  def admin_or_student?
    redirect_to root_path unless current_user.role == 'admin' || current_user.role == 'student'
  end
end
