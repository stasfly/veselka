# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)


user = User.new(
  email: 'admin@admin.com',
  password: 'qwerty',
  password_confirmation: 'qwerty')
user.add_role :admin
user.skip_confirmation_notification!
user.skip_confirmation!
user.save

unless Rails.env.production?
  require 'factory_bot_rails'

  50.times do |n|
    user = User.new(
      email: Faker::Internet.email,
      password: 'qwerty',
      password_confirmation: 'qwerty')
    user.add_role :user
    user.skip_confirmation_notification!
    user.skip_confirmation!
    user.save
    user.cart = Cart.create
  end

  5.times do |n|
    ProductCategory.create(name: "Cat#{n + 1}", description: Faker::Lorem.paragraph)
  end

  product_categories = ProductCategory.all
  10.times do |n|
    product = Product.new(
      name: "item_#{n}",
      description: Faker::Lorem.paragraph,
      sku: "sku_#{n}",
      price: rand(1000)
    )
    product.product_category_id = product_categories.sample.id
    product.save
    ProductInventory.find_by(product_id: product.id).update(quantity: rand(50))
  end

  products = Product.all
  carts = Cart.first(10)
  2.times do |n|
    cart_item = CartItem.new(
      cart_id: carts.sample.id,
      product_id: products.sample.id,
      quantity: rand(5)
    )
    cart_item.save  
  end
end
