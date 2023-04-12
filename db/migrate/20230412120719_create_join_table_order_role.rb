class CreateJoinTableOrderRole < ActiveRecord::Migration[7.0]
  def change
    create_table(:orders_roles, id: false) do |t|
      t.references :order
      t.references :role
    end
    add_index(:orders_roles, [ :order_id, :role_id ])
  end
end
