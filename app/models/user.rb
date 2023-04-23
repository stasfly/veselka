# frozen_string_literal: true

class User < ApplicationRecord
  rolify after_add: :change_role_control, after_remove: :last_admin_remove_protection

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  # validates :password, confirmation: true, length: { minimum: 6, too_short: '%<count>s characters is min allowed' }, allow_blank: true
  # validates :email, uniqueness: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }

  has_many :orders
  has_one :cart, dependent: :destroy

  after_create :send_welcome_email, :asign_default_role, :new_user_cart_create
  # after_update :change_role_control

  def send_welcome_email
    UserMailer.welcome(self).deliver_now unless Rails.env.development?
  end

  private

  def asign_default_role
    add_role(:user) unless has_any_role?
  end

  def new_user_cart_create
    self.cart = Cart.create
  end

  def inactive_orders
    if has_role? :inactive
      orders.map do |order|
        order.add_role :inactive
      end
    end
  end

  def last_admin?
    User.with_role(:admin).count == 1
  end

  def no_admin?
    User.with_role(:admin).count.zero?
  end

  def change_role_control(role)
    if (role.name == 'inactive') || (role.name == 'blocked')
      if (has_role? :admin) && last_admin?
        remove_role(:inactive)
        remove_role(:blocked)
        return puts '@@@@@@@@@@@@@@@@@@@@@@   Last admin protection   @@@@@@@@@@@@@@@@@@@@@@@@@@@@'
      end
      roles.where('name != ? AND name != ?', :inactive, :blocked).each do |role2go|
        remove_role(role2go.name)
      end
      inactive_orders
    end
  end

  def last_admin_remove_protection(role)
    add_role :admin if (role.name == 'admin') && no_admin?
  end
end
