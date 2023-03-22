class CreateProductInventories < ActiveRecord::Migration[7.0]
  def change
    create_table :product_inventories do |t|
      t.integer :quantity

      t.timestamps
    end
  end
end
