# frozen_string_literal: true

class AdminsController < ApplicationController
  def show
    user
  end

  def index
    users
  end

  def edit
    user
  end

  def update
    if user.update(user_params)
      redirect_to users_path, notice: "#{@user.email} roles was successfully updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    user.destroy
    redirect_back fallback_location: root_path, notice: 'User deleted.'
  end

  private

  def users
    @users = User.all
  end

  def user
    # binding.pry
    @user ||= User.find(params[:format])
  end

  def user_params
    params.require(:user).permit({ role_ids: [] }, :email, :password, :password_confirmation, unconfirmed_email: nil)
  end
end
