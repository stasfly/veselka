# frozen_string_literal: true

class CartsController < ApplicationController
  def show
    # binding.pry
    cart
    authorize cart
    cart_sum
    products
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

  def products
    @products = Product.all.with_attached_images
  end
end
