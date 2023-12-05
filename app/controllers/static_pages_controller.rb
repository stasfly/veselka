# frozen_string_literal: true

class StaticPagesController < ApplicationController
  def home
    # binding.pry
    if params[:locale] == 'uk'
      render 'home_uk'
    else
      render 'home'
    end
  end

  def about_project
    if params[:locale] == 'uk'
      render 'about_project_uk'
    else
      render 'about_project'
    end
  end
end
