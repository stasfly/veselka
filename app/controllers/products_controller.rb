# frozen_string_literal: true

class ProductsController < ApplicationController
  def index
    products
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
    if @product.save
      redirect_to @product, notice: 'Product was created'
    else
      render 'new', notice: 'Incorrect input!'
    end
  end

  def update
    product
    if product.update(product_params)
      redirect_to @product, notice: 'Product was updated'
    else
      render :edit, status: 'wrong input'
    end
  end

  def destroy
    product
    @product.destroy
    redirect_to products_path, notice: 'Item destroyed'
  end

  private

  def products
    @products = Product.all
  end

  def product
    @product ||= Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :product_type, :description, :product_code)
  end
end
