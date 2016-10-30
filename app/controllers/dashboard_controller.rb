class DashboardController < ApplicationController
  def index
    redirect_to date_dashboard_path(Date.today - 6.days)
  end

  def dashboard
    # 1. Breakdown by product of sold quantities (based on orders.created_at)
    date = params[:date]
    @day = Date.parse(date)
    @products_sold_count = Order.sold_count_for_week_starting_on(@day)

    # 2. Breakdown by items of sold quantities (based on orders.created_at)
    @items_sold_count = Order.items_sold_count(@day)

    # 3. Add asynchronous navigation to change the displayed week
    # just uses turbolinks, xhr automatically

    # 4. Display order uniq customer count by number of orders (example 1)
    # Order.joins(:customer).group(:customer).count
    orders_by_customer = Order.joins(:customer)
      .from_week_starting_on(@day)
      .group(:customer_id)
      .count

    # key will be number of orders, value will be how many customers ordered (key) times
    # e.g. { 9 => 3} means three customers each had 9 orders
    @orders_count = orders_by_customer.values
      .each
      .with_object(Hash.new(0)) do |order_count, counts|
        counts[order_count] += 1
      end
    @total_orders = @orders_count.values.sum

    # 5. (*On a separate view*) Display repartition between reccuring and new customers for each month (example 2)
  end
end
