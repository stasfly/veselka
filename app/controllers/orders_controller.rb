# frozen_string_literal: true

class OrdersController < ApplicationController
  def index
    if params[:user_id].nil?
      @orders = policy_scope(Order).order(created_at: :desc)
    else
      @orders = Order.where(user_id: params[:user_id])
    end
    authorize @orders
  end

  def show
    @order = order[:order][:order]
    @product_details = order[:order][:product_details]
    authorize @order
  end

  def create
    @order_new = Order.new(user_id: params[:user_id])
    authorize @order_new
    if @order_new.save
      redirect_to order_path(@order_new.id), notice: I18n.t('controllers.orders.created')
    else
      redirect_to cart_path(current_user.cart.id), notice: I18n.t('controllers.orders.error')
    end
  end

  private

  def order
    order ||= Order.order_details(params[:id])
  end

  def order_params
    params.require(:order).permit(:user_id)
  end
end
