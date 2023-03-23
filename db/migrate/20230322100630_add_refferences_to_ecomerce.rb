class AddRefferencesToEcomerce < ActiveRecord::Migration[7.0]
  def change
    
    add_reference(:products, :product_category, foreign_key: true)
    add_reference(:products, :product_inventory, foreign_key: true)
    add_reference(:cart_items, :product, foreign_key: true)
    add_reference(:cart_items, :cart, foreign_key: true)
    add_reference(:order_items, :product, foreign_key: true)
    add_reference(:order_items, :order, foreign_key: true)
    add_reference(:carts, :user, foreign_key: true)
    add_reference(:orders, :user, foreign_key: true)
    
  end
end
