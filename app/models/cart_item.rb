# frozen_string_literal: true

class CartItem < ApplicationRecord
  validates :quantity, numericality: { greater_than: 0 }

  belongs_to :cart
  belongs_to :product

  before_create :update_if_exist

  private

  def update_if_exist
    cart_items = CartItem.where('cart_id = ?', cart_id).where('product_id = ?', product_id)
    cart_items.delete_all if cart_items.any?
  end
end
