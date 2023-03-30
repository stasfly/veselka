class AddProductIdToOrderItem < ActiveRecord::Migration[7.0]
  def change
    add_column :order_items, :product_id, :bigint
  end
end
