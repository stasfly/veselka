# frozen_string_literal: true

require_relative '../services/shared_methods'

class ApplicationController < ActionController::Base
  include Pundit::Authorization
  include Pagy::Backend
  include SharedMethods
  before_action :set_locale
  before_action { @pagy_locale = params[:locale] }

  add_breadcrumb I18n.t('breadcrumbs.home'), :root_path

  def extract_locale
    parsed_locale = params[:locale]
    I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
  end

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def recaptcha_check(action_name, redirect_path)
    if NewGoogleRecaptcha.human?(params[:new_google_recaptcha_token], action_name) || verify_recaptcha
      yield
    else
      # binding.pry
      redirect_to redirect_path
    end
  end

  private

  def product_categories
    @product_categories ||= ProductCategory.all.order(name: :asc)
  end

  def default_url_options
    { locale: I18n.locale }
  end

  def set_locale
    I18n.locale = extract_locale || I18n.default_locale
  end

  def user_not_authorized
    flash[:alert] = I18n.t('controllers.application.access_denied')
    redirect_back(fallback_location: root_path)
  end
end
