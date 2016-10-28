class ProductItem < ActiveRecord::Base
  belongs_to :item
  belongs_to :product
end
