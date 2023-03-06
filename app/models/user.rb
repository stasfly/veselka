# frozen_string_literal: true

class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  # validates :password, confirmation: true, length: { minimum: 6, too_short: '%<count>s characters is min allowed' }, allow_blank: true
  # validates :email, uniqueness: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }

  after_create :send_welcome_email, :asign_default_role

  def send_welcome_email
    UserMailer.welcome(self).deliver_now
  end

  private

  def asign_default_role
    add_role(:user) unless has_any_role?
  end
end
