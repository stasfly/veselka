# frozen_string_literal: true

class OrderItem < ApplicationRecord
  validates :quantity, presence: true
  validates :quantity, numericality: { only_integer: true }
  belongs_to :order
end
