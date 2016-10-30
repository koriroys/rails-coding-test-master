class Order < ActiveRecord::Base
  belongs_to :product
  belongs_to :customer

  scope :from_week_starting_on, -> (start_date) { where(created_at: start_date..(start_date + 7.days))}

  enum status: [:draft, :confirmed, :canceled]
end
