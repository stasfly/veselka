# frozen_string_literal: true

class ProductsController < ApplicationController
  def index
    products
    # binding.pry
  end

  def show
    product
  end

  def new
    @product = Product.new
  end

  def edit
    product
  end

  def create
    @product = Product.new(product_params)
    if @product.valid?
      @product.save
      redirect_to @product, notice: 'Product was created'
    else
      # flash.now[:message] = 'Sorry, Incorrect input!'
      render :new, notice: 'Incorrect input!'
    end
  end

  def update
    product
    # binding.pry
    if product.update(product_params)
      redirect_to @product, notice: 'Product was updated'
    else
      flash.now[:message] = 'Sorry, Incorrect input!'
      render :edit, status: 'wrong input'
    end
  end

  def destroy
    product
    @product.destroy
    redirect_to products_path, notice: 'Item destroyed'
  end

  def purge_one_attachment
    # binding.pry
    attachment = ActiveStorage::Attachment.find(params[:id])
    attachment.purge
    redirect_back fallback_location: root_path, notice: 'Image has been deleted'
  end

  def purge_all_attachments
    # binding.pry
    product.images.purge
    redirect_back fallback_location: root_path, notice: 'All images have been deleted'
  end

  private

  def products
    @products = Product.all.with_attached_images
  end

  def product
    @product ||= Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :product_type, :description, :product_code, images: [])
  end
end
