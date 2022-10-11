# frozen_string_literal: true

class ProductsController < ApplicationController
  def index
    products
  end

  def show
    product
  end

  def new; end

  def edit; end

  def create; end

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
