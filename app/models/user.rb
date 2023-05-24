# frozen_string_literal: true

class User < ApplicationRecord
  rolify after_add: :change_role_control, after_remove: :last_admin_remove_protection

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  # validates :password, confirmation: true, length: { minimum: 6, too_short: '%<count>s characters is min allowed' }, allow_blank: true
  # validates :email, uniqueness: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }

  has_many :orders, -> { order(created_at: :desc) }
  has_one :cart, dependent: :destroy

  after_create :send_welcome_email, :asign_default_role, :new_user_cart_create

  def self.user_search(search = nil)
    # search {
    #   email: '',
    #   role: '',
    #   "created_at_to(3i)" #day
    #   "created_at_to(2i)" #month
    #   "created_at_to(1i)" #year
    #   "created_at_from(3i)" #day
    #   "created_at_from(2i)" #month
    #   "created_at_from(1i)" #year
    #   "order_created_at_to(3i)" #day
    #   "order_created_at_to(2i)" #month
    #   "order_created_at_to(1i)" #year
    #   "order_created_at_from(3i)" #day
    #   "order_created_at_from(2i)" #month
    #   "order_created_at_from(1i)" #year
    #   order_email: '',
    #   order_role: '',
    #   order_created_at: '',
    # }
    if search

      search_date_from =  [search['created_at_from(1i)'],
                           search['created_at_from(2i)'],
                           search['created_at_from(3i)']].join('-')
      search_date_to =    [search['created_at_to(1i)'],
                           search['created_at_to(2i)'],
                           search['created_at_to(3i)']].join('-')

      date_to = begin
        DateTime.parse(search_date_to)
      rescue StandardError
        Time.now
      end
      date_from = begin
        DateTime.parse(search_date_from)
      rescue StandardError
        (Time.now - 20.years)
      end

      order_search_date_from =  [search['order_created_at_from(1i)'],
                                 search['order_created_at_from(2i)'],
                                 search['order_created_at_from(3i)']].join('-')
      order_search_date_to =    [search['order_created_at_to(1i)'],
                                 search['order_created_at_to(2i)'],
                                 search['order_created_at_to(3i)']].join('-')

      order_date_to = begin
        DateTime.parse(order_search_date_to)
      rescue StandardError
        nil
      end
      order_date_from = begin
        DateTime.parse(order_search_date_from)
      rescue StandardError
        nil
      end

      if order_date_to || order_date_from
        order_date_to = begin
          DateTime.parse(order_search_date_to)
        rescue StandardError
          Time.now
        end
        order_date_from = begin
          DateTime.parse(order_search_date_from)
        rescue StandardError
          (Time.now - 20.years)
        end
      end

      sort_key = search[:sort].split.first.to_sym
      sort_order = search[:sort].split.last.upcase.to_sym

      users = eager_load(:orders, :roles)
              .left_outer_joins(:roles, :orders)
              .where('roles.name LIKE ?', "%#{search[:role]}%")
              .where('email LIKE ?', "%#{search[:email]}%")
              .where(created_at: (date_from..date_to))
              .distinct
      users = users.where(orders: { created_at: (order_date_from..order_date_to) }) unless order_date_to.nil?
      users = users.order(sort_key => sort_order) if search[:sort]
    else
      left_outer_joins(:roles, :orders).includes(:orders, :roles).uniq
    end
  end

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
