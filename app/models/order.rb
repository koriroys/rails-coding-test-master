class Order < ActiveRecord::Base
  belongs_to :product
  belongs_to :customer
  has_many :items, through: :product

  scope :from_week_starting_on, -> (start_date) { where(created_at: start_date..(start_date + 7.days))}

  scope :sold_count_for_week_starting_on, -> (start_date) {
    joins(:product)
      .from_week_starting_on(start_date)
      .group(:product)
      .count
  }

  scope :by_customer, -> (start_date) {
    joins(:customer)
      .from_week_starting_on(start_date)
      .group(:customer_id)
      .count
  }

  def self.items_sold_count(start_date)
    sold_count = includes(:items)
      .from_week_starting_on(start_date)
      .map(&:items)
      .flatten
      .group_by { |item| item.id }
      .map { |k, v| [k, v.size] }
      .to_h

    items = Item.find(sold_count.keys)

    items.map { |item| [item, sold_count[item.id]] }.to_h
  end

  def self.orders_count_by_customer_for_week_starting_on(start_date)
    by_customer(start_date)
      .values
      .each
      .with_object(Hash.new(0)) do |order_count, counts|
        counts[order_count] += 1
      end
  end

  enum status: [:draft, :confirmed, :canceled]
end
