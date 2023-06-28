# frozen_string_literal: true

class ProductCategoriesController < ApplicationController
  before_action :product_category, only: %i[show edit update destroy]
  before_action :authorize_product_category, only: %i[edit update destroy]
  add_breadcrumb I18n.t('breadcrumbs.products'), :product_categories_path, only: %i[index show new edit]

  def index
    product_categories
    # binding.pry
  end

  def show
    add_breadcrumb product_category.name, product_category_path(product_category)
    # if params[:source] == 'index'
    render 'products/index', params: { product_category_id: product_category.id }
    # else
    # redirect_to products_path#(product_category_id: @product.product_category.id)
    # binding.pry
    # end
  end

  def new
    @product_category = ProductCategory.new
    add_breadcrumb I18n.t('breadcrumbs.product_category_new'), new_product_category_path
    authorize_product_category
  end

  def create
    @product_category = ProductCategory.new(product_category_params)
    authorize_product_category
    if @product_category.valid?
      @product_category.save
      redirect_back fallback_location: product_categories_path
    else
      render :new, notice: I18n.t('controllers.products.incorrect_input')
    end
  end

  def edit
    product_categories
    @product_category ||= ProductCategory.includes(products: { product_inventory: %i[id product_id
                                                                                     quantity] }).where(id: params[:id])
    @products = Product.where(product_category: @product_category.id).includes(:product_inventory)
    add_breadcrumb I18n.t('breadcrumbs.product_category_edit'), edit_product_category_path(product_category)
    # binding.pry
  end

  def update
    authorize_product_category
    binding.pry
    if product_category.update(product_category_params)
      product_category.products.map do |product|
        # params[:product_category][:products_attributes]['0'][:id]
      end
      redirect_to product_categories_path, notice: I18n.t('controllers.product_categories.updated')
    else
      render :edit, status: I18n.t('controllers.products.incorrect_input')
    end
  end

  def destroy
    authorize_product_category
    redirect_to product_categories_path, notice: I18n.t(safe_delete(product_category))
  end

  private

  def product_categories
    @product_categories = ProductCategory.all
  end

  def product_category
    @product_category ||= ProductCategory.find(params[:id])
  end

  def authorize_product_category
    authorize @product_category
  end

  def safe_delete(category_item)
    associated_products = Product.where(product_category_id: category_item.id)
    if associated_products == []
      category_item.delete
      message = 'controllers.product_categories.deleted'
    else
      unsorted = unsorted_category
      associated_products.map do |product|
        product.update(product_category_id: unsorted.id)
      end
      if category_item == unsorted
        message = 'controllers.product_categories.deletion_forbidden'
      else
        category_item.delete
        message = 'controllers.product_categories.deleted'
      end
    end
  end

  def product_category_params
    params.require(:product_category).permit(:name, :description, :source, :product_category_id, :locale, :id,
                                             search: %i[name cost_from cost_to sort product_category_id],
                                             products_attributes: [:name, :price, :id, :_destroy,
                                                                   { product_inventory_attributes: %i[quantity id] }])
  end
end
