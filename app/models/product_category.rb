# frozen_string_literal: true

class ProductCategory < ApplicationRecord
  has_many :products

  validates :name, length: { maximum: 100, too_long: '%<count>s characters is max allowed' }, presence: true
  validates :description, length: { in: 3..1200,
                                    too_long: '%<count>s characters is max allowed',
                                    too_short: '%<count>s characters is min allowed' }
end
