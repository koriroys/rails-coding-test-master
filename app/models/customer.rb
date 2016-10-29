class Customer < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :orders

  after_create :generate_fake_orders

  def generate_fake_orders
    product_ids = Product.pluck(:id)
    5.times do
      timestamp = Faker::Time.between(2.weeks.ago, DateTime.now)
      orders.create(
        product_id: product_ids.sample,
        status: Order.statuses.values.sample,
        created_at: timestamp,
        updated_at: timestamp)
    end
  end
end
