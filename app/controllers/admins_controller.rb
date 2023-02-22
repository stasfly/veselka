# frozen_string_literal: true

class AdminsController < ApplicationController
  #   def new
  #     @user = User.new
  #   end

  def show
    user
  end

  def index
    users
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
    params.require(:user).permit(:email)
  end
end
