class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :product_id, null: false
      t.integer :status, null: false
      t.integer :customer_id, null: false
      t.timestamps null: false
    end
  end
end
