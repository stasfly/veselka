# frozen_string_literal: true

class OrdersController < ApplicationController
  def show
    order
  end

  def create
    order_new = Order.new(user_id: params[:user_id])
    # binding.pry
    if order_new.save
      # @order = order_new
      redirect_to order_path(order_new.id), notice: 'Order successfully created'
    else
      redirect_to cart_path(current_user.cart.id), notice: 'Error has been occured'
    end
  end

  private

  def order
    @order ||= Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:user_id)
  end
end
