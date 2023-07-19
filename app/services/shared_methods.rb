# frozen_string_literal: true

module SharedMethods
  def unsorted_category
    unless ProductCategory.find_by(name: 'Unsorted')
      return ProductCategory.create(name: 'Unsorted',
                                    description: 'Unsortet products')
    end
    ProductCategory.find_by(name: 'Unsorted')
  end
end
