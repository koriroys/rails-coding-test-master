class CreateProductItems < ActiveRecord::Migration
  def change
    create_table :product_items do |t|
      t.integer :product_id, null: false
      t.integer :item_id, null: false
      t.integer :quantity, default: 0
    end
  end
end
