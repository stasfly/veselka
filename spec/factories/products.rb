# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    # product_category = create(:product_category)
    name { Faker::Vehicle.make }
    price { rand(1..100) }
    sku { Faker::Vehicle.mileage }
    description { Faker::ChuckNorris.fact }
  end

  trait :product_inventory do
    after(:create) do |product|
      product.product_inventory.quantity = 10
    end
  end
end
