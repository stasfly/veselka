# frozen_string_literal: true

module Users
  class PasswordsController < Devise::PasswordsController
    # GET /resource/password/new
    # def new
    #   super
    # end

    # POST /resource/password
    def create
      yield_block = proc do
        super
      end
      redirect_path = new_user_password_path(user: { email: params[:user][:email] }, show_checkbox_recaptcha: true)
      recaptcha_check('new_password', redirect_path, &yield_block)
    end

    # GET /resource/password/edit?reset_password_token=abcdef
    # def edit
    #   super
    # end

    # PUT /resource/password
    def update
      yield_block = proc do
        super
      end
      redirect_path = edit_user_password_path(user: { email: params[:user][:email] }, show_checkbox_recaptcha: true)
      recaptcha_check('edit_password', redirect_path, &yield_block)
    end

    # protected

    # def after_resetting_password_path_for(resource)
    #   super(resource)
    # end

    # The path used after sending reset password instructions
    # def after_sending_reset_password_instructions_path_for(resource_name)
    #   super(resource_name)
    # end
  end
end
