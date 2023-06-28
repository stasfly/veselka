class ChangePriceDefaultOnProducts < ActiveRecord::Migration[7.0]
  def change
    change_column_default :products, :price, to: 0 
  end
end
