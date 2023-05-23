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

  scope :user_id_eq, ->(user_id) { where('id = ?', user_id) }

  # 25.04 may by should remove to admins_conroller
  def role_search(role = '')
    Role.where.("name ILIKE ?", "%#{role}%").order(:name)
  end

  def search_user_by_role(roles)
    @users = []
    roles.map do |role|
      @users.push(self) if self.has_role? role
    end
    @users.uniq!
  end
  #25.04

  #27.04

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
    #   amount_to: '',
    #   amount_from: '',
    #   orders_value: '',
    #   created_at: '',
    #   order_email: '',
    #   order_role: '',
    #   order_created_at: '',
    # }
    if search
      search_date_from =  [search["created_at_from(1i)"], search["created_at_from(2i)"], search["created_at_from(3i)"]].join('-')
      search_date_to =  [search["created_at_to(1i)"], search["created_at_to(2i)"], search["created_at_to(3i)"]].join('-')
      date_to = DateTime.parse(search_date_to) rescue Time.now
      date_from = DateTime.parse(search_date_from) rescue (Time.now - 20.years)
      users = self.eager_load(:orders, :roles).left_outer_joins(:roles, :orders)
        .where("roles.name LIKE ?", "%#{search[:role]}%")
        .where("email LIKE ?", "%#{search[:email]}%")
        .where(created_at: (date_from..date_to))
        .order(:id).distinct # should work
      # binding.pry
      # self.order(email: :asc) unless search[:order_email].nil?
      users.order(email: :asc) unless search[:order_email].nil?
      # self.order("roles.name ASC") unless search[:order_role].nil? # should try
      users.order("roles.name ASC") unless search[:order_role].nil? # should try
    else
      # users = User.all
      users = self.left_outer_joins(:roles, :orders).includes(:orders, :roles).uniq
        # binding.pry
    end
    return users
  end
  
  #27.04

  def self.role_eq(role)
    with_role(role)
  end

  def send_welcome_email
    UserMailer.welcome(self).deliver_now unless Rails.env.development?
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[confirmation_sent_at confirmed_at created_at email id remember_created_at
       reset_password_sent_at unconfirmed_email updated_at]
    # ["confirmation_sent_at", "confirmation_token", "confirmed_at", "created_at", "email", "encrypted_password", "id", "remember_created_at", "reset_password_sent_at", "reset_password_token", "unconfirmed_email", "updated_at"]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[cart orders roles]
  end

  #25.04
  def self.ransackable_scopes(auth_object = nil)
    %i(search_user_by_role)
  end
  #25.04

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
