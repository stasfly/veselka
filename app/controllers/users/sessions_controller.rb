# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    before_action :configure_sign_in_params, only: [:create]

    # GET /resource/sign_in
    def new
      add_breadcrumb I18n.t('breadcrumbs.sign_in'), new_user_session_path
      super
    end

    # POST /resource/sign_in
    def create
      # binding.pry
      inspected_user = User.find_by(email: params[:user][:email])
      if inspected_user && (inspected_user.has_role? :blocked)
        redirect_to(new_user_session_path,
                    notice: "Account with email: #{params[:user][:email]} has been blocked. You cannot use it anymore.")
      elsif inspected_user && (inspected_user.has_role? :inactive)
        redirect_to(new_user_registration_path,
                    alert: "Account with email: #{params[:user][:email]} has been canceled. To restore it use sign up form.")
      else
        super
      end
    end

    # DELETE /resource/sign_out

    protected

    # If you have extra params to permit, append them to the sanitizer.
    def configure_sign_in_params
      devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
    end
  end
end
