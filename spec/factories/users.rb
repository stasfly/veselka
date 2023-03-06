# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'qwerty' }
    password_confirmation { password }
  end
end
