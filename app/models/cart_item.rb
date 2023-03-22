# frozen_string_literal: true

class CartItem < ApplicationRecord
  belongs_to :cart
  has_one :product
end
