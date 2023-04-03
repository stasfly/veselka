# frozen_string_literal: true

class CartItem < ApplicationRecord
  validates :quantity, numericality: { greater_than: 0 } # , less_than_or_equal_to: ProductInventory.find_by(product_id: self.product_id).quantity}

  belongs_to :cart
  belongs_to :product
end
