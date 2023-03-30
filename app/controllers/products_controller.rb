# frozen_string_literal: true

class ProductsController < ApplicationController

    before_action :product_categories, only: [:new, :edit]
    before_action :product, only: [:show, :edit, :edit, :destroy]

  def index
    products
  end

  def show
    # product
    @cart_item = CartItem.new(product_id: product.id, cart_id: current_user.cart.id)
    # binding.pry
  end

  def new
    @product = Product.new
  end

  def edit
    # product
  end

  def create
    @product = Product.new(product_params)
    # @product.quantity = params[:inventory_quantity][:quantity]
    # binding.pry
    if @product.valid?
      @product.save
      params[:inventory_quantity][:quantity] = 0 if params[:inventory_quantity][:quantity] = nil
      ProductInventory.create(product_id: @product.id, quantity: (params[:inventory_quantity][:quantity] || 0))
      redirect_to @product, notice: 'Product was created'
    else
      render :new, notice: 'Incorrect input!'
    end
  end

  def update
    # product
    if product.update(product_params)
      redirect_to @product, notice: 'Product was updated'
    else
      flash.now[:message] = 'Sorry, Incorrect input!'
      render :edit, status: 'wrong input'
    end
  end

  def destroy
    # product
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

  def product_params
    params.require(:product).permit(:name, :description, :sku, :price, :product_category_id, :quantity, images: [])
  end
end
