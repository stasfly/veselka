# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'stasfly.ruby.developer@gmail.com'
  layout 'mailer'
end
