class DashboardController < ApplicationController
  def index
    # 1. Breakdown by product of sold quantities (based on orders.created_at)
    day = Date.today - 7.days
    @products_sold_count = Order.joins(:product).from_week_starting_on(day).group(:product).count


    # 2. Breakdown by items of sold quantities (based on orders.created_at)
    items_sold_count = Order.includes(:items)
      .from_week_starting_on(day)
      .map(&:items)
      .flatten
      .group_by { |item| item.id }
      .map { |k, v| [k, v.size] }
      .to_h

    items = Item.find(items_sold_count.keys)

    @items_sold_count = items.map { |item| [item, items_sold_count[item.id]] }.to_h

    # 3. Add asynchronous navigation to change the displayed week
    # 4. Display order uniq customer count by number of orders (example 1)
    # 5. (*On a separate view*) Display repartition between reccuring and new customers for each month (example 2)
  end
end
