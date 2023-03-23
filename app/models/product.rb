# frozen_string_literal: true

class Product < ApplicationRecord
  validates :name, length: { maximum: 100 }, presence: true
  validates :description, length: { in: 3..1200,
                                    too_long: '%<count>s characters is max allowed',
                                    too_short: '%<count>s characters is min allowed' },
                          allow_nil: true

  # validates :images, content_type:  { in: %w[image/jpeg image/gif image/png],
  #                                     message: "must be a valid image format" },
  #                     size:
  #                                   { less_than: 5.megabytes,
  #                                     message: "should be less than 5MB" }
  belongs_to :product_category

  has_many_attached :images
  has_one :product_inventory
end
