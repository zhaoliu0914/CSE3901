# frozen_string_literal: true

module Users
  class PasswordsController < Devise::PasswordsController
    prepend_before_action :require_no_authentication, only: :cancel
    # before_action :redirect_signed_in_user, only: [:edit]

    # GET /resource/password/new

    # POST /resource/password

    # GET /resource/password/edit?reset_password_token=abcdef
    def edit
      raw, encrypted = Devise.token_generator.generate(User, :reset_password_token)

      @user = User.find(current_user.id)
      @user.reset_password_token = encrypted
      @user.update_columns(reset_password_token: encrypted, reset_password_sent_at: Time.current.utc)

      super

      resource.reset_password_token = raw
    end

    # PUT /resource/password
    def update
      # self.resource_class.reset_password_token = current_user.email
      # self.resource.reset_password_token = current_user.email
      print(params[:user][:reset_password_token])
      super
    end

    # protected

    def redirect_signed_in_user
      return unless user_signed_in?

      redirect_to edit_user_password_path
    end

    # def after_resetting_password_path_for(resource)
    #   super(resource)
    # end

    # The path used after sending reset password instructions
    # def after_sending_reset_password_instructions_path_for(resource_name)
    #   super(resource_name)
    # end
  end
end
