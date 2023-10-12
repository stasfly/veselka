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

    trait :admin do
      after(:create) do |user|
        user.add_role :admin
      end
    end

    trait :no_admin do
      after(:create) do |user|
        user.add_role :user
      end
    end

    trait :blocked do
      after(:create) do |user|
        user.add_role :blocked
      end
    end

    trait :inactive do
      after(:create) do |user|
        user.add_role :inactive
      end
    end
  end
end
