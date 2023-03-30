# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items

  after_create :cart_order_transaction
  # around_create :cart_order_transaction

  private

  def cart_order_transaction
    cart_items = CartItem.all.where(cart_id: User.find(self.user_id).cart.id)
    order_cost = 0
    cart_items.map do |cart_item|
      cart_item_cost = Product.find(cart_item.product_id).price
      OrderItem.create(
        order_id: self.id,
        product_id: cart_item.product_id,
        quantity: cart_item.quantity,
        item_cost: cart_item_cost
      )
      order_cost += cart_item.quantity * cart_item_cost
      cart_item.delete
    end
    self.update(cost: order_cost)
    OrderMailer.order_confirmation_message(self).deliver_later
    OrderMailer.incoming_order(self).deliver_later
  end

end
