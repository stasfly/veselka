# frozen_string_literal: true

require 'rails_helper'
require 'devise/test_helpers'

RSpec.describe '/admins/users', type: :request do
  # include Devise::Test::ControllerHelpers

  let!(:user) { create(:user, :admin) }

  # before do
  #   @request = ActionDispatch::Request.new(Rails.application.env_config)
  #   @request.env['action_controller.instance'] = @controller
  #   sign_in(user, password: 'qwerty')
  # end

  describe 'get /index' do
    it 'renders successful response' do
      get root_path
      expect(response).to render_template(:index)
      expect(response).to have_http_status(:success)
    end
  end
end
