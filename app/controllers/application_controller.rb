# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit::Authorization
  include Pagy::Backend
  before_action :set_locale
  before_action { @pagy_locale = params[:locale] }

  add_breadcrumb I18n.t('breadcrumbs.home'), :root_path

  def extract_locale
    parsed_locale = params[:locale]
    I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
  end

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # protected

  private

  def unsorted_category
    unless ProductCategory.find_by(name: 'Unsorted')
      return ProductCategory.create(name: 'Unsorted',
                                    description: 'Unsortet products')
    end

    ProductCategory.find_by(name: 'Unsorted')
  end

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
