# frozen_string_literal: true

class CartsController < ApplicationController
  def show
    cart
    authorize cart
    cart_sum
  end

  private

  def cart
    @cart ||= Cart.includes(cart_items: :product).where(id: params[:id]).sample
  end

  def cart_sum
    @cart_sum = 0
    cart.cart_items.map do |cart_item|
      @cart_sum += cart_item.quantity * cart_item.product.price
    end
  end
end
