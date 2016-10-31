## Installation

`cd rails-coding-test-master`
`bundle`
`bundle exec rake db:create db:migrate db:seed`
`bundle exec rails server`

Open localhost:3000 in a browser. Explore!

## Tasks Implemented

Please implement the following  stories.

1. An order belongs to a Customer.

2. A product belongs to a Category.

3. Any customer browse to an account page and is prompted with a login page. They enter their credentials (login and password) and are presented with exactly their orders (sorted by status).

4. Write a SQL query to return the results as display below:

***Example***

customer_id | customer_first_name | category_id | category_name
--- | --- | --- | --- | ---
1 |John | 1 | Bouquets

run in sqlite3 console

`SELECT cu.id, cu.firstname, p.id, cat.id, cat.name
FROM customers cu
JOIN orders o
ON o.customer_id = cu.id
JOIN products p
ON o.product_id = p.id
JOIN categories cat
ON cat.id = p.category_id;`

5. Use active record methods to achieve the result above.

run in rails console

`Customer.select("customers.id as customer_id", "customers.firstname as customer_first_name", "categories.id as category_id", "categories.name as category_name").joins(orders: { product: :category })`

6. Extend ruby Hash Class to use your own implementation of the [Hash#dig](http://ruby-doc.org/core-2.3.0_preview1/Hash.html#method-i-dig) method without ruby 2.3. Make it available in the Rails app.

A library already exists that does this, so why would I re-invent it? Just adding the gem to Gemfile makes it available to use in the Rails app. Plus it is tested and seems to follow the Ruby 2.3 behavior. So I will use that: e.g.: https://github.com/Invoca/ruby_dig

7. Analytics

  To see the weekly summary, navigate to localhost:3000/dashboard

  *We need a weekly summary page displaying:*
  1. Breakdown by product of sold quantities (based on orders.created_at)
  2. Breakdown by items of sold quantities (based on orders.created_at)
  3. Add asynchronous navigation to change the displayed week
  4. Display order uniq customer count by number of orders (example 1)

  To see the recurring customers, navigate to localhost:3000/dashboard/customers

  5. (*On a separate view*) Display repartition between reccuring and new customers for each month (example 2)

***Example 1***

Orders|Customers|Percentage
----|----|----
1 order|70|70%
2 orders|20|20%
3 orders|5|5%

***Example 2***

Month|Reccuring Customer|New customer|Total
----|----|----|----
June 2016|0|800|800
July 2016|15|290|305

# Additional questions
*No coding necessary, explain the concept or sketch your thoughts.*

- We want to add a subscription feature to allow our customers to receive flower automaticaly. How would you design the tables, what are the pros and cons of your approach?

I'd likely look for a payment processor that allows us to subscribe customers to subscriptions, rather than trying to work out all the fun bits of charging cards monthly myself. And since the feature will expand to need a free month at the start, a discount if you buy a whole year, offer refunds, change the charged amount, etc., I'd look hard at something like Stripe or Braintree (or the European equivalent).

On the app side, I'd probably just have a simple `Customer: has_many: :subscriptions`, and in the Subscriptions table, include the id of the subscription from the payment processor, then fetch the details from the external service when needed.

The advantage of this approach is that you get it deployed fast, and you also get loads of the things you'd want from subscriptions for free from the service: delayed subscription start, yearly subscription discounts, set the delivery interval (daily if you're really in love with someone?), option for seasonal flower selection, etc.

The disadvantage is there might be some domain specific things we'd want to do that the external service isn't flexible enough to do.

- When facing a high traffic and limited supply, how do you distribute the stock among clients checking out?

The easiest way from the developer point of view would be just to process requests as they are received, with the customer experience of being told the sale can't be completed when they try to check out. A better customer experience might be to show how many items are left, and allow the customer to add the item to their basket, with a timer saying they need to check out within X minutes to keep the item, or it will be released back into the item pool to be purchased by someone else. Similar to how something like a ticket sales site works.
