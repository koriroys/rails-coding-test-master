class DashboardController < ApplicationController
  def index
    redirect_to date_dashboard_path(Date.today - 6.days)
  end

  def dashboard
    @day = Date.parse(params[:date])
    @products_sold_count = Order.sold_count_for_week_starting_on(@day)

    @items_sold_count = Order.items_sold_count(@day)

    @orders_count = Order.orders_count_by_customer_for_week_starting_on(@day)
    @total_orders = @orders_count.values.sum

    # 5. (*On a separate view*) Display repartition between reccuring and new customers for each month (example 2)
  end

  def customers

    # build list of month ranges to get orders for that month
    oldest_order_date = Date.parse(Order.order(:created_at).first.created_at.to_s)
    order_date = oldest_order_date.dup
    today = Date.today
    month_ranges = []

    while order_date < today do
      month_ranges << order_date.all_month
      order_date = order_date.next_month
    end

    # get customers who ordered each month
    @customers_by_month = month_ranges.map do |month|
      [month.first.strftime("%B %Y"), Customer.unique_in_month(month).to_a]
    end

    old_customers = []

    @new_and_old_customers = @customers_by_month.map { |month_name, this_month_customers|
      # new customers are any customers seen this month who haven't been seen in previous months
      # i.e. they are not in the old customers list yet
      new_customers = this_month_customers - old_customers

      # repeat customers are customers from this month who are already in the old customers list,
      # e.g. the intersection of the two lists
      repeat_customers = this_month_customers & old_customers

      # all new and old customers from this month get added to old_customers for next month
      # with duplicates removed
      old_customers |= this_month_customers


      [month_name, repeat_customers.size, new_customers.size, this_month_customers.size]
    }
  end
end
