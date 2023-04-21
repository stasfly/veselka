# frozen_string_literal: true

class Product < ApplicationRecord
  validates_presence_of :name, message: I18n.t('activerecord.errors.models.product.attributes.name.presence')
  # validates :name, presence: true
  validates :name, length: { maximum: 100, too_long: '%<count>s characters is max allowed' } # , presence: true
  validates :description, length: { in: 3..1200,
                                    too_long: '%<count>s characters is max allowed',
                                    too_short: '%<count>s characters is min allowed' }

  # validates :images, content_type:  { in: %w[image/jpeg image/gif image/png],
  #                                     message: "must be a valid image format" },
  #                     size:
  #                                   { less_than: 5.megabytes,
  #                                     message: "should be less than 5MB" }
  belongs_to :product_category

  has_many_attached :images
  has_many :cart_items, dependent: :destroy
  has_one :product_inventory, dependent: :destroy
end
