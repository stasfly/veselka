# frozen_string_literal: true

class CartItem < ApplicationRecord
  validates :quantity, numericality: { greater_than: 0 } # , less_than_or_equal_to: ProductInventory.find_by(product_id: self.product_id).quantity}

  belongs_to :cart
  belongs_to :product

  before_create :update_if_exist

  private

  def update_if_exist
    cart_item = CartItem.where('cart_id = ?', self.cart_id).where('product_id = ?', self.product_id)
    if cart_item.any?
      cart_item.delete_all
    end
  end

end
