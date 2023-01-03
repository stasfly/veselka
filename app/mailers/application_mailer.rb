# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'veselka@example.com'
  layout 'mailer'
end
