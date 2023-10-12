# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProductCategory, type: :model do
  describe 'test ProductCategory model' do
    context 'check validations' do
      it { should have_many(:products) }
      it { should validate_presence_of(:name) }
      it { should validate_length_of(:name).with_message('must be 100 characters or less') }
      it 'validate description' do
        expect(ProductCategory.new(name: 'some_name', description: nil)).to be_invalid
        desc = 'a' * 1201
        expect(ProductCategory.new(name: 'some_name', description: desc)).to be_invalid
        desc = 'a' * 2
        expect(ProductCategory.new(name: 'some_name', description: desc)).to be_invalid
      end
      it { should accept_nested_attributes_for(:products).allow_destroy(true) }
    end

    context 'CRUD operations test' do
      # Create test
      it 'should create a new product category' do
        product_category = create(:product_category)

        expect(product_category).to be_valid
      end

      # Update test
      it 'should update a product category' do
        product_category = create(:product_category)

        product_category.name = 'New name'
        product_category.description = 'New description'

        product_category.save

        expect(product_category.name).to eq('New name')
        expect(product_category.description).to eq('New description')
      end

      # Destroy test
      it 'should destroy a product category' do
        product_category = create(:product_category)

        product_category.destroy

        expect(ProductCategory.find_by(id: product_category.id)).to be_nil
      end
    end
  end
end
