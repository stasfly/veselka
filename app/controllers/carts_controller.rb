# frozen_string_literal: true

class CartsController < ApplicationController
  def show
    # binding.pry
    cart
    authorize cart
    cart_sum
    cart_items
  end

  private

  def cart
    @cart ||= Cart.find(params[:id])
    # @cart ||= Cart.find_by(user_id: current_user.id)
  end

  def cart_sum
    @cart_sum = 0
    cart.cart_items.map do |cart_item|
      @cart_sum += cart_item.quantity * cart_item.product.price
    end
  end

  def cart_items
    @cart_items = CartItem.where(cart_id: cart.id)
  end
end
