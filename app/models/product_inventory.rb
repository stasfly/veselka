# frozen_string_literal: true

class ProductInventory < ApplicationRecord
  belongs_to :product, dependent: :destroy
end
