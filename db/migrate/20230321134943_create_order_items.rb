class CreateOrderItems < ActiveRecord::Migration[7.0]
  def change
    create_table :order_items do |t|
      t.integer :quantity
      t.decimal :item_cost, precision: 6, scale: 2

      t.timestamps
    end
  end
end
