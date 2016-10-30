class DashboardController < ApplicationController
  def index
    redirect_to date_dashboard_path(Date.today - 6.days)
  end

  def dashboard
    # 1. Breakdown by product of sold quantities (based on orders.created_at)
    date = params[:date]
    @day = Date.parse(date)
    @products_sold_count = Order.joins(:product).from_week_starting_on(@day).group(:product).count


    # 2. Breakdown by items of sold quantities (based on orders.created_at)
    items_sold_count = Order.includes(:items)
      .from_week_starting_on(@day)
      .map(&:items)
      .flatten
      .group_by { |item| item.id }
      .map { |k, v| [k, v.size] }
      .to_h

    items = Item.find(items_sold_count.keys)

    @items_sold_count = items.map { |item| [item, items_sold_count[item.id]] }.to_h

    # 3. Add asynchronous navigation to change the displayed week
    # just uses turbolinks, xhr automatically

    # 4. Display order uniq customer count by number of orders (example 1)
    # Order.joins(:customer).group(:customer).count
    orders_by_customer = Order.joins(:customer).group(:customer_id).count

    # key will be number of orders, value will be how many customers ordered (key) times
    # e.g. { 9 => 3} means three customers each had 9 orders
    @orders_count = orders_by_customer.values.each.with_object(Hash.new(0)) { |order_count, counts| counts[order_count] += 1 }
    @total_orders = @orders_count.values.sum

    # 5. (*On a separate view*) Display repartition between reccuring and new customers for each month (example 2)
  end
end
