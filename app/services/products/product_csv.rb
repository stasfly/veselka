# frozen_string_literal: true

module Products
  class ProductCsv
    require 'csv'

    def csv_import(file, product_categories)
      opened_file = File.open(file)
      @products = []
      @uploaded_products = CSV.parse(opened_file, col_sep: ';', headers: true)
      @uploaded_products.each_with_index do |record, index|
        next if record['name'].blank?

        prod_cat = if product_categories.detect { |cat| cat[:id] == record['product_category_id'].to_i }
                     record['product_category_id']
                   else
                     product_categories.where(name: 'Unsorted').sample.id
                   end
        prod_id = record['id'].blank? ? "new_#{index + 1}" : record['id']
        row = { id: prod_id,
                name: record['name'],
                sku: record['sku'],
                price: record['price'],
                description: record['description'],
                product_category_id: prod_cat,
                quantity: record['quantity'] }
        @products << row
      end
      @products.map(&:to_h)
    end

    def csv_export(product_category_name)
      prods = if product_category_name.blank?
                Product.all.includes(:product_inventory)
              else
                Product.includes(:product_inventory)
                       .where(product_category_id: ProductCategory.find_by(name: product_category_name))
              end
      CSV.generate do |csv|
        csv << %w[product_category_id id sku name price quantity updated_at description] # Product.column_names
        prods.each do |prod|
          ary = []
          ary << prod.product_category_id
          ary << prod.id
          ary << prod.sku
          ary << prod.name
          ary << prod.price
          ary << prod.product_inventory.quantity
          ary << prod.updated_at.strftime('%Y-%m-%d %H:%M:%S')
          ary << prod.description
          csv << ary
        end
      end
    end

    def bulk_product_update(bulk_product_params, product_categories)
      prods_before_update = Product.all.includes(:product_inventory)
      bulk_product_params.each do |_id, attributes|
        prod_cat = product_categories.detect { |cat| cat[:name] == attributes[:product_category_id] } ||
                   product_categories.detect { |cat| cat[:name] == 'Unsorted' }
        prod =  if prods_before_update.detect { |record| record[:id] == attributes[:id].to_i }
                  prods_before_update.detect { |record| record[:id] == attributes[:id].to_i }
                elsif prods_before_update.detect do |record|
                        (record[:name] == attributes[:name]) && (record[:sku] == attributes[:sku])
                      end
                  prods_before_update.detect { |record| record[:name] == attributes[:name] }
                else
                  Product.new
                end
        prod.id = nil if prod.id.to_i.zero?
        if prod.id && attributes[:dstr].to_i == 1
          remove_to_unsort?(prod)
        else
          prod.name = attributes[:name]          unless prod.name == attributes[:name]
          prod.sku = attributes[:sku]            unless prod.sku == attributes[:sku]
          prod.price = attributes[:price]        unless prod.price == attributes[:price]
          prod.product_category_id = prod_cat.id unless prod.product_category_id == prod_cat.id
          prod.description = 'No description' if prod.description.blank?
          prod.save if prod.id.nil?
          unless prod.product_inventory.quantity == attributes[:product_inventory][:quantity]
            prod.product_inventory.update(quantity: attributes[:product_inventory][:quantity])
          end
          prod.save if prod.changed?
        end
      end
    end
  end
end
