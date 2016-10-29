class AccountController < ApplicationController
  before_action :authenticate_customer!

  def index
    @orders = current_customer.orders.order(:status)
  end
end
