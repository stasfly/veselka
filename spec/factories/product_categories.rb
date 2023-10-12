# frozen_string_literal: true

FactoryBot.define do
  factory :product_category do
    name { Faker::Vehicle.make }
    description { Faker::ChuckNorris.fact }

    trait :with_product_instance do
      after(:create) do |product_category|
        create(:product, :product_inventory, product_category:)
      end
    end
  end
end
