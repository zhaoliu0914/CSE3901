class UsersController < ApplicationController

  def show
    redirect_to users_approval_path
  end
  def approval
    @pagy, @users = pagy(User.where(role: "admin_waiting"), items: 10)
  end

  def approval_update
    print("params[:id] = " + params[:id])
    @user = User.find(params[:id])
    @user.update_column(:role, "admin")

    redirect_to users_approval_path
  end
  
  private

end