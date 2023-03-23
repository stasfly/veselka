class DeleteProductCodeInProduct < ActiveRecord::Migration[7.0]
  
  def change
    remove_column(:products, :product_type)
  end
end
