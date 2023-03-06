# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    name { Faker::Vehicle.make }
    product_type { Faker::Vehicle.car_type }
    product_code { Faker::Vehicle.mileage }
    description { Faker::ChuckNorris.fact }
  end
end
