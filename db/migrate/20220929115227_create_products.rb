class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.string :product_type
      t.text :description
      t.integer :product_code
      

      t.timestamps
    end
  end
end
