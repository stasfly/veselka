# frozen_string_literal: true

class AdminsController < ApplicationController
  before_action :authorize_user, only: %i[show edit update destroy]
  def show
    # binding.pry
    user
  end

  def index
    # binding.pry
    @pagy, @users = pagy(User.user_search(params[:search]), items: (params[:items] || 6))
    # @users = User.user_search(params[:search]) # || users
    authorize current_user.nil? ? User.new : current_user
  end

  def edit
    user
  end

  def update
    if params[:set_user_role] == 'blocked'
      @user.add_role :blocked
      redirect_to users_path, notice: "#{@user.email} #{I18n.t('controllers.admins.blocked')}"
    elsif user.update(user_params)
      redirect_to users_path, notice: "#{@user.email} #{I18n.t('controllers.admins.updated')}"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    user.destroy
    redirect_back fallback_location: root_path, notice: I18n.t('controllers.admins.destroyed')
  end

  private

  def users
    @users = User.all
  end

  def user
    @user ||= User.find(params[:id])
  end

  def authorize_user
    authorize user
  end

  def user_params
    params.require(:user).permit({ role_ids: [] }, :search, :email, :password,
                                 :password_confirmation, unconfirmed_email: nil)
  end
end
