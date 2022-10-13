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

  def edit; end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to @product
    else
      render 'new'
    end
  end

  def update; end

  def delete; end

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
