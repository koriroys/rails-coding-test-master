class DashboardController < ApplicationController
  def index
    redirect_to date_dashboard_path(Date.today - 6.days)
  end

  def dashboard
    @day = Date.parse(params[:date])
    @products_sold_count = Order.sold_count_for_week_starting_on(@day)

    @items_sold_count = Order.items_sold_count(@day)

    # key will be number of orders, value will be how many customers ordered (key) times
    # e.g. { 9 => 3} means three customers each had 9 orders
    @orders_count = Order.orders_count_by_customer_for_week_starting_on(@day)
    @total_orders = @orders_count.values.sum

    # 5. (*On a separate view*) Display repartition between reccuring and new customers for each month (example 2)
  end
end
