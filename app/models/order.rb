class Order < ActiveRecord::Base
  has_one :product

  enum status: [:daft, :confirmed, :canceled]
end
