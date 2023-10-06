# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'qwerty' }
    password_confirmation { password }

    trait :with_cart_item do
      after(:create) do |user|
        product_category = create(:product_category)
        product = create(:product, :product_inventory, product_category:)
        cart_item = create(:cart_item, cart: user.cart, product:)
      end
    end
  end
end
