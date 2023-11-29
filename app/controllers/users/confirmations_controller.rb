# frozen_string_literal: true

module Users
  class ConfirmationsController < Devise::ConfirmationsController
  # GET /resource/confirmation/new
  # def new
  #   super
  # end

  # POST /resource/confirmation
  def create
    yield_block = proc do
      super
    end
    redirect_path = new_user_confirmation_path(user: { email: params[:user][:email] }, show_checkbox_recaptcha: true)
    recaptcha_check('new_confirmation', redirect_path, &yield_block)
  end

  # GET /resource/confirmation?confirmation_token=abcdef
  # def show
  #   super
  # end

  # protected

  # The path used after resending confirmation instructions.
  # def after_resending_confirmation_instructions_path_for(resource_name)
  #   super(resource_name)
  # end

  # The path used after confirmation.
  # def after_confirmation_path_for(resource_name, resource)
  #   super(resource_name, resource)
  # end
  end
end
