# frozen_string_literal: true

class AdminsController < ApplicationController
  before_action :authorize_user, only: %i[show edit update destroy]
  add_breadcrumb I18n.t('breadcrumbs.users'), :users_path, only: %i[index show]

  def show
    user
    add_breadcrumb @user.email, user_path
  end

  def index
    incoming_params = params.permit(:locale, :format, :page,
                                    search: [:email, :role, :sort,
                                             'created_at_to(3i)', 'created_at_to(2i)', 'created_at_to(1i)',
                                             'created_at_from(3i)', 'created_at_from(2i)', 'created_at_from(1i)',
                                             'order_created_at_to(3i)', 'order_created_at_to(2i)', 'order_created_at_to(1i)',
                                             'order_created_at_from(3i)', 'order_created_at_from(2i)', 'order_created_at_from(1i)'])
    @pagy, @users = pagy(User.user_search(incoming_params[:search]), items: 6)
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
    params.require(:user).permit({ role_ids: [] }, :search, :email, :password, :locale,
                                 :password_confirmation, unconfirmed_email: nil)
  end
end
