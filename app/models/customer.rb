class Customer < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :orders

  scope :unique_in_month, -> (month) {
    joins(:orders).where("orders.created_at": month).uniq
  }
end
