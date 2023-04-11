# frozen_string_literal: true

class CartItem < ApplicationRecord
  validates :quantity, numericality: { only_integer: true, greater_than_or_equal_to: 1 }, presence: true

  belongs_to :cart
  belongs_to :product

  before_create :update_if_exist

  private

  def update_if_exist
    cart_items = CartItem.where('cart_id = ?', cart_id).where('product_id = ?', product_id)
    cart_items.delete_all if cart_items.any?
  end
end
