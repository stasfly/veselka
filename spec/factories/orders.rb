# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    user_id { create(:user) }
  end
end
