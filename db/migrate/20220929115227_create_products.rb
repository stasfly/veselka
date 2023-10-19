class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.string :sku
      t.text :description
      t.integer :product_code
      t.decimal :price, precision: 6, scale: 2, default: 0

      t.timestamps
    end
  end
end
