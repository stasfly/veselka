# frozen_string_literal: true

class CartItemsController < ApplicationController
  def create
    @cart_item = CartItem.new(cart_item_params)
    if @cart_item.valid?
      @cart_item.save
      # redirect_back fallback_location: root_path, notice:'Item is added to your cart'
      redirect_to products_path, notice: 'Item is added to your cart'
    else
      render 'products/show', notice: 'Incorrect quanrtity of the Item.'
    end
  end

  def update
    cart_item
    # binding.pry
    cart_item.update(cart_item_params)
  end

  def destroy
    cart_item
    @cart_item.destroy
  end

  private

  def cart_item
    @cart_item ||= CartItem.find(params[:id])
  end

  def cart_item_params
    params.require(:cart_item).permit(:quantity, :cart_id, :product_id)
  end
end
