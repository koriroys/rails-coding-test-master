# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

40.times do
  Item.create!(name: Faker::Commerce.material)
end

3.times do
  Category.create(name: Faker::Color.color_name)
end

item_ids = Item.pluck(:id)
category_ids = Category.pluck(:id)
30.times do
  p = Product.create(name: Faker::Book.title, price: Faker::Commerce.price, category_id: category_ids.sample)
  item_ids.sample(rand(5) + 2).each do |item_id|
    p.product_items.create!(item_id: item_id, quantity: (rand(10) + 1) )
  end
end

c = Customer.create!(firstname: "Bob", email: "bob@example.com", password: "bobone")
c2 = Customer.create!(firstname: "James", email: "james@example.com", password: "james1")
c3 = Customer.create!(firstname: "Koko", email: "koko@example.com", password: "kokobongo")

created_datetime = Faker::Time.between(2.weeks.ago, DateTime.now)
product_ids = Product.pluck(:id)
statuses = Order.statuses.values
15.times do
  created_datetime = Faker::Time.between(2.weeks.ago, DateTime.now)
  c.orders.create!(product_id: product_ids.sample, status: statuses.sample, created_at: created_datetime, updated_at: created_datetime)
end

5.times do
  created_datetime = Faker::Time.between(2.weeks.ago, DateTime.now)
  c2.orders.create!(product_id: product_ids.sample, status: statuses.sample, created_at: created_datetime, updated_at: created_datetime)
end

7.times do
  created_datetime = Faker::Time.between(2.weeks.ago, DateTime.now)
  c3.orders.create!(product_id: product_ids.sample, status: statuses.sample, created_at: created_datetime, updated_at: created_datetime)
end