# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit::Authorization
  before_action :set_locale
  # around_action :switch_locale

  def extract_locale
    parsed_locale = params[:locale]
    I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
  end

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

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
