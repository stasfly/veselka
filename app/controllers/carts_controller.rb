# frozen_string_literal: true

class CartsController < ApplicationController
  def show
    cart
    products
  end

  private

  def cart
    @cart ||= Cart.find_by(user_id: current_user.id)
  end

  def products
    @products = Product.all.with_attached_images
  end
end
