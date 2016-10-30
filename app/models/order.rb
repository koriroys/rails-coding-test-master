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

  enum status: [:draft, :confirmed, :canceled]
end
