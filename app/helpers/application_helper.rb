# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  def current_user_admin?
    current_user && (current_user.has_role? :admin)
  end
end
