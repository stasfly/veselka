# frozen_string_literal: true

class OrdersController < ApplicationController
  add_breadcrumb I18n.t('breadcrumbs.orders'), :orders_path, only: %i[index show]

  def index
    @pagy, @orders = if params[:user_id].nil?
                       pagy(policy_scope(Order.order_search(params[:search]&.permit!)), items: 10)
                     else
                       pagy(Order.where(user_id: params[:user_id]).order(created_at: :desc), items: 5)
                     end
    authorize @orders
  end

  def show
    order
    add_breadcrumb @order.id, order_path
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
    order_hash ||= Order.order_details(params[:id])
    @order = order_hash[:order][:order]
    @product_details = order_hash[:order][:product_details]
  end

  def order_params
    params.require(:order).permit(:user_id)
  end
end
