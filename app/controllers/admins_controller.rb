# frozen_string_literal: true

class AdminsController < ApplicationController
  before_action :authorize_user, only: %i[show edit update destroy]
  def show
    user
  end

  def index
    @q = User.ransack(params[:q])
    @users = @q.result(distinct: true)
    # binding.pry
    @users = sort_users_by_role(@users, params[:q])
    # users
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

  def role_scope_sort(order = nil)
    case order
    when 'active_roles desc'
      Role.pluck(:name).sort { |a, b| b <=> a }
    when 'active_roles asc'
      Role.pluck(:name).sort
    else
      Role.pluck(:name)
    end
  end

  def sort_users_by_role(unsorted_users, query_param_to_sort = nil)
    if query_param_to_sort.nil?
      unsorted_users
    elsif query_param_to_sort['s'].nil?
      unsorted_users
    else
      sorted_users = []
      users_pull = unsorted_users
      role_scope_sort(query_param_to_sort['s']).map do |role|
        users_pull.map do |user|
          if user.has_role? role
            sorted_users.push(user) # see also .shift method
            # unsorted_users.delete(user)
          end
        end
        users_pull -= sorted_users
      end
      unsorted_users = sorted_users
    end
  end

  def user_params
    params.require(:user).permit({ role_ids: [] }, :email, :password, :password_confirmation, unconfirmed_email: nil)
  end
end
