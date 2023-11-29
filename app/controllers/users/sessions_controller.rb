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
      yield_block = proc do
        inspected_user = User.find_by(email: params[:user][:email])
        if inspected_user && (inspected_user.has_role? :blocked)
          redirect_to(new_user_session_path,
                      notice: "#{I18n.t('controllers.users.sessions.account_with_email')} 
                                #{params[:user][:email]} 
                                #{I18n.t('controllers.users.sessions.been_blocked')}")
        elsif inspected_user && (inspected_user.has_role? :inactive)
          redirect_to(new_user_registration_path,
                      alert: "#{I18n.t('controllers.users.sessions.account_with_email')} 
                              #{params[:user][:email]} 
                              #{I18n.t('controllers.users.sessions.been_canceled')}")
        else
          super
        end
      end
      redirect_path = new_user_session_path(user: { email: params[:user][:email] },
                                                        show_checkbox_recaptcha: true)
      recaptcha_check('login', redirect_path, &yield_block)
    end

    # DELETE /resource/sign_out

    protected

    # If you have extra params to permit, append them to the sanitizer.
    def configure_sign_in_params
      devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
    end
  end
end
