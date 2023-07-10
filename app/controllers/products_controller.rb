# frozen_string_literal: true

class ProductsController < ApplicationController
  before_action :product_categories, only: %i[new edit]
  before_action :product, only: %i[show edit update destroy]
  before_action :authorize_product, only: %i[edit]

  add_breadcrumb I18n.t('breadcrumbs.products'), :product_categories_path, only: %i[index show new edit]

  def index
    incoming_params = params.permit(:locale, :format, :page,
                                    search: %i[product_category_id cost_from cost_to name sort])
    @pagy, @products = pagy(Product.product_search(incoming_params[:search]), items: 3)
    @cart_item = CartItem.new
    @products_in_cart = current_user.nil? ? [] : Product.products_in_cart(current_user.id)
    product_category_bread_crumb
  end

  def show
    @cart_item = CartItem.new(product_id: product.id, cart_id: current_user.cart.id) unless current_user.nil?
    product_inventory
    @product_in_cart = Product.products_in_cart(current_user.id).include?(product.id) unless current_user.nil?
    add_breadcrumb @product.product_category.name,
                   product_category_path(@product.product_category_id,
                                         product_category_id: @product.product_category_id)
    add_breadcrumb @product.name, product_path
  end

  def new
    @product = Product.new
    add_breadcrumb I18n.t('breadcrumbs.product_new'), new_product_path
    authorize_product
  end

  def edit; end

  def create
    @product = Product.new(product_params)
    authorize_product
    if @product.valid?
      @product.save
      ProductInventory.create(product_id: @product.id, quantity: params[:inventory_quantity][:quantity].to_i)
      redirect_to @product, notice: I18n.t('controllers.products.created')
    else
      render :new, notice: I18n.t('controllers.products.incorrect_input')
    end
  end

  def update
    # @product = Product.find(params[:id])
    authorize_product
    if product.update(product_params)
      product_inventory = ProductInventory.find_by(product_id: @product.id)
      stock_quantity =  product_inventory.quantity + params[:inventory_quantity][:quantity].to_i
      stock_quantity = 0 if stock_quantity.negative?
      product_inventory.update(quantity: stock_quantity)
      redirect_to @product, notice: I18n.t('controllers.products.updated')
    else
      render :edit, status: I18n.t('controllers.products.incorrect_input')
    end
  end

  def destroy
    authorize_product
    remove_to_unsort?(@product)
    redirect_to products_path(product_category_id: @product.product_category.id),
                notice: I18n.t('controllers.products.destroyed')
  end

  def purge_one_attachment
    attachment = ActiveStorage::Attachment.find(params[:id])
    attachment.purge
    redirect_back fallback_location: root_path, notice: I18n.t('controllers.products.image_destroyed')
  end

  def purge_all_attachments
    product.images.purge
    redirect_back fallback_location: root_path, notice: I18n.t('controllers.products.all_images_destroyed')
  end

  def bulk_update
    # binding.pry
    product_categories
    prods_before_update = Product.where(product_category_id: params[:id]).includes(:product_inventory)
    bulk_product_params.each do |_id, attributes|
      prod = prods_before_update.detect { |record| record[:id] == attributes[:id].to_i }
      prod_cat = @product_categories.detect { |cat| cat[:name] == attributes[:product_category_id] }
      if attributes[:dstr].to_i == 1
        remove_to_unsort?(prod)
      else
        prod.update(name: attributes[:name])          unless prod.name == attributes[:name]
        prod.update(sku: attributes[:sku])            unless prod.sku == attributes[:sku]
        prod.update(price: attributes[:price])        unless prod.price == attributes[:price]
        prod.update(product_category_id: prod_cat.id) unless prod.product_category_id == prod_cat.id
        unless prod.product_inventory.quantity == attributes[:product_inventory][:quantity]
          prod.product_inventory.quantity = attributes[:product_inventory][:quantity]
          prod.save
        end
      end
    end
    redirect_to product_categories_path, notice: I18n.t('controllers.products.bulk_update')
  end

  # POST
  def csv_accept
    require 'csv'
    return redirect_to request.referer, notice: 'No file added' if params[:file].nil?
    return redirect_to request.referer, notice: 'Only CSV files allowed' unless params[:file].content_type == 'text/csv'

    opened_file = File.open(params[:file])
    options = { headers: true, col_sep: ';' }
    @products = []
    @uploaded_products = CSV.parse(opened_file, col_sep: ';', headers: true)
    @uploaded_products.each do |record|
      next if record['name'].blank?

      row = { id: record['id'],
              name: record['name'],
              sku: record['sku'],
              price: record['price'],
              description: record['description'],
              product_category_id: record['product_category_id'],
              quantity: record['quantity'] }
      @products << row
    end
    # binding.pry
    redirect_to csv_edit_path(products: @products)
  end

  # GET
  def csv_edit
    product_categories
    @products = params[:products]
    # @products_to_edit = CSV.parse(csv_str, col_sep: ',', headers: true)
    # binding.pry
  end

  # PUT
  def csv_update
    product_categories
    prods_before_update = Product.all.includes(:product_inventory)
    bulk_product_params.each do |_id, attributes|
      prod = prods_before_update.detect { |record| record[:id] == attributes[:id].to_i }
      prod_cat = @product_categories.detect { |cat| cat[:name] == attributes[:product_category_id] }
      if attributes[:dstr].to_i == 1
        remove_to_unsort?(prod)
      else
        prod.update(name: attributes[:name])          unless prod.name == attributes[:name]
        prod.update(sku: attributes[:sku])            unless prod.sku == attributes[:sku]
        prod.update(price: attributes[:price])        unless prod.price == attributes[:price]
        prod.update(product_category_id: prod_cat.id) unless prod.product_category_id == prod_cat.id
        unless prod.product_inventory.quantity == attributes[:product_inventory][:quantity]
          prod.product_inventory.quantity = attributes[:product_inventory][:quantity]
          prod.save
        end
      end
    end
    redirect_to product_categories_path, notice: I18n.t('controllers.products.bulk_update')
  end

  private

  def products
    @products = Product.includes(:product_category, :product_inventory, [:images_attachments]) # .with_attached_images
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

  def product_category_bread_crumb
    if params[:product_category_id]
      crumb_name = ProductCategory.find(params[:product_category_id]).name
    elsif params[:search] && params[:search][:product_category_id].present?
      crumb_name = ProductCategory.find(params[:search][:product_category_id]).name
    end
    add_breadcrumb crumb_name unless crumb_name.nil?
  end

  def remove_to_unsort?(product_item)
    unsorted = unsorted_category
    if product_item.product_category_id == unsorted.id
      product_item.destroy
    else
      product_item.update(product_category_id: unsorted.id)
    end
  end

  def bulk_product_params
    products = params.require(:product).permit!
    products.each do |id, attributes|
      products[id] = attributes.permit(:id, :name, :description, :sku, :price, :product_category_id, :dstr,
                                       :quantity, product_inventory: %i[quantity id])
    end
  end

  def product_params
    params.require(:product).permit(:name, :description, :sku, :price, :product_category_id, :quantity, images: [])
  end
end
