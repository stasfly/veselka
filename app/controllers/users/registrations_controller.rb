# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    before_action :configure_sign_up_params, only: [:create]
    before_action :configure_account_update_params, only: [:update]

    # GET /resource/sign_up

    def create
      if inspected_user = User.find_by(email: params[:user][:email])
        if inspected_user.has_role? :blocked
          return redirect_to new_user_registration_path,
                             notice: "The account with email: #{inspected_user.email} has been blocked. You cannot use this email"
        elsif inspected_user.has_role? :inactive
          inspected_user.remove_role :inactive
          return redirect_to new_user_session_path, notice: 'Your acount now is an active. log in please'
        end
      else
        return super
      end
      super
    end

    def update
      @user.add_role :inactive
      @user.update(updated_at: Time.now)
      sign_out @user
      redirect_to root_path, notice: "Account with email: #{@user.email} has canceled"
    end

    # GET /resource/cancel
    # Forces the session data which is usually expired after sign
    # in to be expired now. This is useful if the user wants to
    # cancel oauth signing in/up in the middle of the process,
    # removing all OAuth session data.

    protected

    # If you have extra params to permit, append them to the sanitizer.
    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
    end

    # If you have extra params to permit, append them to the sanitizer.
    def configure_account_update_params
      devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
    end

    # The path used after sign up.

    # The path used after sign up for inactive accounts.
  end
end
