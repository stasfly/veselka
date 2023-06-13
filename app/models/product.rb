# frozen_string_literal: true

class Product < ApplicationRecord
  validates_presence_of :name, message: I18n.t('activerecord.errors.models.product.attributes.name.presence')
  # validates :name, presence: true
  validates :name, length: { maximum: 100, too_long: '%<count>s characters is max allowed' } # , presence: true
  validates :description, length: { in: 3..1200,
                                    too_long: '%<count>s characters is max allowed',
                                    too_short: '%<count>s characters is min allowed' }

  # validates :images, content_type:  { in: %w[image/jpeg image/gif image/png],
  #                                     message: "must be a valid image format" },
  #                     size:
  #                                   { less_than: 5.megabytes,
  #                                     message: "should be less than 5MB" }
  belongs_to :product_category

  has_many_attached :images
  has_many :cart_items, dependent: :destroy
  has_one :product_inventory, dependent: :destroy

  def self.product_search(search)
    if search
      sort_key    = sort_key_order(search[:sort])[:key]
      sort_order  = sort_key_order(search[:sort])[:order]

      search[:cost_from] ||= ''
      search[:cost_to] ||= ''
      cost_from = search[:cost_from]  == '' ? 0 : search[:cost_from]
      cost_to   = search[:cost_to]    == '' ? 1_000_000_000_000 : search[:cost_to]
      product = Product.includes(:product_inventory, [:images_attachments]) # .joins(:user)
                       .where('name LIKE ?', "%#{search[:name]}%")
                       .where('price BETWEEN ? AND ?', cost_from, cost_to)
                       .distinct
                       .order(sort_key => sort_order)
      unless search[:product_category_id].blank?
        product = product.where(product_category_id: search[:product_category_id])
      end
      product
    else
      Product.includes(:product_inventory, [:images_attachments]).order(created_at: :desc).distinct
    end
  end

  def self.products_in_cart(user_id)
    user = User.includes(cart: :cart_items).where(id: user_id).sample
    products_in_cart = []
    user.cart.cart_items.map { |cart_item| products_in_cart << cart_item.product_id }
    products_in_cart
  end
end
