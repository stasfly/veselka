class Product < ApplicationRecord
  validates :name, length: { maximum: 100 }
  validates :description, length: { in: 3..1200,
                                    too_long: "%{count} characters is max allowed",
                                    too_short: "%{count} characters is min allowed"},
                                    allow_nil: true
  validates :product_type, length: { maximum: 20, too_long: "%{count} characters is max allowed" }
  validates :product_code, numericality: { only_integer: true,
                                          message: -> (object, data) do
                                            if object.product_code.nil? 
                                              "Please insert unique product code"
                                            elsif object.product_code == data[:value]
                                              "Another object has already contained: #{data[:value]} value"
                                            else
                                              "#{data[:value]} seems to be not integer"
                                            end
                                          end },
                          uniqueness: true, on: :update

end
