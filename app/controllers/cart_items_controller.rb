# frozen_string_literal: true

class CartItemsController < ApplicationController
  def create
    @cart_item = CartItem.new(cart_item_params)
    authorize cart_item
    if @cart_item.valid?
      @cart_item.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update("cart_item_form_#{@cart_item.product.id}", partial: 'products/cart_item_form',
                                                                           locals: { product: @cart_item.product })
          ]
        end
      end
    else
      redirect_to products_path, notice: 'Incorrect quanrtity of the Item.'
    end
  end

  def update
    authorize cart_item
    cart_item.update(cart_item_params)
  end

  def destroy
    authorize cart_item
    if cart_item.destroy
      if cart_item.cart.cart_item_ids.any?
        cart_sum
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: [
              turbo_stream.remove(@cart_item),
              turbo_stream.update('cart_sum', partial: 'carts/cart_sum')
            ]
          end
        end
      else
        redirect_to cart_path(current_user.cart.id)
      end
    end
  end

  private

  def cart_item
    @cart_item ||= CartItem.find(params[:id])
  end

  def cart_sum
    @cart_sum = 0
    cart_item.cart.cart_items.map do |cart_item|
      @cart_sum += cart_item.quantity * cart_item.product.price
    end
  end

  def authorize_cart_item
    authorize cart_item
  end

  def cart_item_params
    params.require(:cart_item).permit(:quantity, :cart_id, :product_id)
  end
end
