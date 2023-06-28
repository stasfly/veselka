# frozen_string_literal: true

class OrdersController < ApplicationController
  add_breadcrumb I18n.t('breadcrumbs.orders'), :orders_path, only: %i[index show]

  def index
    # binding.pry
    incoming_params = params.permit(:locale, :format, :page,
                                    search: [:email, :sort, :cost_from, :cost_to,
                                             'order_created_at_to(3i)', 'order_created_at_to(2i)', 'order_created_at_to(1i)',
                                             'order_created_at_from(3i)', 'order_created_at_from(2i)', 'order_created_at_from(1i)'])
    @pagy, @orders = if params[:user_id].nil?
                       pagy(policy_scope(Order.order_search(incoming_params[:search])), items: 10)
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
