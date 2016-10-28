class Product < ActiveRecord::Base
  has_many :orders
  has_many :product_items
  has_many :items, through: :product_items
end
