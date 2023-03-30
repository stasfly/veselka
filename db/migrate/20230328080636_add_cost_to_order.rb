class AddCostToOrder < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :cost, :float
  end
end
