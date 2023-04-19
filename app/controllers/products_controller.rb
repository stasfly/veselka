# frozen_string_literal: true

class ProductsController < ApplicationController
  before_action :product_categories, only: %i[new edit]
  before_action :product, only: %i[show edit edit destroy]
  before_action :authorize_product, only: %i[edit update destroy]

  def index
    if params[:query].nil?
      products
      @products.order('name ASC')
    else
      @products = Product.where(product_category_id: params[:query][:product_category_id].to_i).order('id ASC')
    end
    product_inventories
    @cart_item = CartItem.new
  end

  def show
    @cart_item = CartItem.new(product_id: product.id, cart_id: current_user.cart.id) unless current_user.nil?
    product_inventory
  end

  def new
    @product = Product.new
    authorize_product
  end

  def edit; end

  def create
    @product = Product.new(product_params)
    authorize_product
    if @product.valid?
      @product.save
      params[:inventory_quantity][:quantity] = 0 if params[:inventory_quantity][:quantity].nil?
      ProductInventory.create(product_id: @product.id, quantity: (params[:inventory_quantity][:quantity] || 0))
      redirect_to @product, notice: 'Product was created'
    else
      render :new, notice: 'Incorrect input!'
    end
  end

  def update
    if product.update(product_params)
      product_inventory = ProductInventory.find_by(product_id: @product.id)
      stock_quantity =  product_inventory.quantity + params[:inventory_quantity][:quantity].to_i
      stock_quantity = 0 if stock_quantity.negative?
      product_inventory.update(quantity: stock_quantity)
      redirect_to @product, notice: 'Product was updated'
    else
      flash.now[:message] = 'Sorry, Incorrect input!'
      render :edit, status: 'wrong input'
    end
  end

  def destroy
    @product.destroy
    redirect_to products_path, notice: 'Item destroyed'
  end

  def purge_one_attachment
    attachment = ActiveStorage::Attachment.find(params[:id])
    attachment.purge
    redirect_back fallback_location: root_path, notice: 'Image has been deleted'
  end

  def purge_all_attachments
    product.images.purge
    redirect_back fallback_location: root_path, notice: 'All images have been deleted'
  end

  private

  def products
    @products = Product.all.with_attached_images
  end

  def product_categories
    @product_categories = ProductCategory.all
  end

  def product
    @product ||= Product.find(params[:id])
  end

  def product_inventories
    @product_inventories ||= ProductInventory.all
  end

  def product_inventory
    @product_inventory ||= ProductInventory.find_by(product_id: product.id)
  end

  def authorize_product
    authorize @product
  end

  def product_params
    params.require(:product).permit(:name, :description, :sku, :price, :product_category_id, :quantity, images: [])
  end
end
