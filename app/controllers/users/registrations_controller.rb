# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    before_action :configure_sign_up_params, only: [:create]
    before_action :configure_account_update_params, only: [:update]

    def new
      add_breadcrumb I18n.t('breadcrumbs.registration'), new_user_registration_path
      super
    end

    def create
      yield_block = proc do
        inspected_user = User.find_by(email: params[:user][:email])
        if inspected_user && (inspected_user.has_role? :blocked)
          return redirect_to new_user_registration_path,
            notice: "#{I18n.t('controllers.users.sessions.account_with_email')}
                     #{inspected_user.email} 
                     #{I18n.t('controllers.users.sessions.been_blocked')}"
        elsif inspected_user && (inspected_user.has_role? :inactive)
          inspected_user.remove_role :inactive
          inspected_user.add_role :user
          return redirect_to new_user_session_path, notice: I18n.t('controllers.users.registrations.account_is_active')
        end
        return super
      end
      redirect_path = new_user_registration_path(user: { email: params[:user][:email] }, show_checkbox_recaptcha: true)
      recaptcha_check('signup', redirect_path, &yield_block)
    end

    def edit
      add_breadcrumb current_user.email, user_path(current_user.id)
      super
    end

    def update
      yield_block = proc do
        super
      end
      redirect_path = edit_user_registration_path(user: { email: params[:user][:email] }, show_checkbox_recaptcha: true)
      recaptcha_check('edit_account', redirect_path, &yield_block)
    end

    def destroy
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
