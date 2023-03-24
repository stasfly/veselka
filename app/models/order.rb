# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items

  after_create :cart_order_transfer
  # around_create :cart_order_transfer

  private

  def cart_order_transfer
    cart_items = CartItem.all.where(cart_id: User.find(self.user_id).cart.id)
    cart_items.map do |cart_item|
      OrderItem.create(
        order_id: self.id,
        product_id: cart_item.product_id,
        quantity: cart_item.quantity,
        item_cost: Product.find(cart_item.product_id).price
      )
      cart_item.delete
    end
  end

end
