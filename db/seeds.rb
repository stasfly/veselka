# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require 'factory_bot_rails'

user = User.new(
  email: 'admin@admin.com',
  password: 'qwerty',
  password_confirmation: 'qwerty')
user.add_role :admin
user.save

3.times do |n|
  user = User.new(
    email: "u#{n}@u.com",
    password: 'qwerty',
    password_confirmation: 'qwerty')
  user.add_role :user
  user.save
  # user.cart = Cart.create
end

3.times do |n|
  ProductCategory.create(name: "Cat#{n}")
end

product_categories = ProductCategory.all
10.times do |n|
  product = Product.new(
    name: "item#{n}",
    description: Faker::Lorem.paragraph,
    sku: "sku#{n}",
    price: rand(1000)
  )
  product.product_category_id = product_categories.sample.id
  product.save
  product_inventory = ProductInventory.create(quantity: rand(20), product_id: product.id)
end

products = Product.all
carts = Cart.all
20.times do |n|
  cart_item = CartItem.new(
    cart_id: carts.sample.id,
    product_id: products.sample.id,
    quantity: rand(10)
  )
  cart_item.save  
end
# FactoryBot.create_list(:product, 8)
# FactoryBot.create_list(:user, 2)
