# frozen_string_literal: true

class Order < ApplicationRecord
  rolify
  belongs_to :user
  has_many :order_items

  after_create :cart_order_transaction

  def self.order_details(order_id)
    order = Order.includes(:order_items).where(id: order_id).sample
    # binding.pry
    product_ids = order.order_items.map(&:product_id)
    products = Product.where(id: product_ids)
    product_details = {}
    products.map do |product|
      product_details[product.id] = { name: product.name, price: product.price }
    end
    Hash.new(order:, product_details:)
  end

  def self.order_search(search = nil)
    if search
      order_date_to   = date_conv('to', search['order_created_at_to(1i)'],
                                  search['order_created_at_to(2i)'],
                                  search['order_created_at_to(3i)'])
      order_date_from = date_conv('from', search['order_created_at_from(1i)'],
                                  search['order_created_at_from(2i)'],
                                  search['order_created_at_from(3i)'])
      sort_key    = sort_key_order(search[:sort])[:key]
      sort_order  = sort_key_order(search[:sort])[:order]

      cost_from = search[:cost_from]  == '' ? 0 : search[:cost_from]
      cost_to   = search[:cost_to]    == '' ? 1_000_000_000_000 : search[:cost_to]
      # binding.pry
      Order.includes(:user).joins(:user)
           .where('users.email LIKE ?', "%#{search[:email]}%")
           .where('cost BETWEEN ? AND ?', cost_from, cost_to)
           .where(created_at: (order_date_from..order_date_to))
           .distinct
           .order(sort_key => sort_order)
    else
      Order.includes(:user).order(created_at: :desc).distinct
    end
  end

  private

  def cart_order_transaction
    cart_items = CartItem.all.where(cart_id: User.find(user_id).cart.id)
    order_cost = 0
    cart_items.map do |cart_item|
      cart_item_cost = Product.find(cart_item.product_id).price
      OrderItem.create(
        order_id: id,
        product_id: cart_item.product_id,
        quantity: cart_item.quantity,
        item_cost: cart_item_cost
      )
      order_cost += cart_item.quantity * cart_item_cost
      product_inventory = ProductInventory.find_by(product_id: cart_item.product_id)
      product_inventory.update(quantity: (product_inventory.quantity - cart_item.quantity))
      cart_item.delete
    end
    update(cost: order_cost)
    OrderMailer.order_confirmation_message(self).deliver_later
    OrderMailer.incoming_order(self).deliver_later
  end
end
