# frozen_string_literal: true

class Product < ApplicationRecord
  validates :name, length: { maximum: 100 }, presence: true
  validates :description, length: { in: 3..1200,
                                    too_long: '%<count>s characters is max allowed',
                                    too_short: '%<count>s characters is min allowed' },
                          allow_nil: true
  validates :product_type, length: { maximum: 20, too_long: '%<count>s characters is max allowed' }
  validates :product_code, numericality: { only_integer: true,
                                           message: lambda do |object, data|
                                                      if object.product_code.nil?
                                                        'Please insert unique product code'
                                                      elsif object.product_code == data[:value]
                                                        "Another object has already contained: #{data[:value]} value"
                                                      else
                                                        "#{data[:value]} seems to be not integer"
                                                      end
                                                    end },
                           uniqueness: true, on: :update
  # validates :images, content_type:  { in: %w[image/jpeg image/gif image/png],
  #                                     message: "must be a valid image format" },
  #                     size:
  #                                   { less_than: 5.megabytes,
  #                                     message: "should be less than 5MB" }
  has_many_attached :images
end
