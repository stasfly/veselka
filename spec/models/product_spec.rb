# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'test ProductCategory model' do
    context 'check validations' do
      it { should have_one(:product_inventory) }
      it { should have_many(:cart_items).dependent(:destroy) }
      it { should have_many_attached(:images) }
      it { should belong_to(:product_category) }
      it { should validate_presence_of(:name) }
      it { should validate_length_of(:name).with_message('must be 100 characters or less') }
      it 'validate description' do
        product_category = create(:product_category)
        product = create(:product, product_category:)
        product.description = nil
        expect(product).to be_invalid
        product.description = 'a' * 1201
        expect(product).to be_invalid
        product.description = 'aa'
        expect(product).to be_invalid
      end
      it { is_expected.to have_db_column(:price).of_type(:decimal) }
      it 'validate price' do
        product_category = create(:product_category)
        product = create(:product, product_category:)
        product.price = nil
        expect(product).to be_valid
      end
    end

    context 'CRUD operations test' do
      it 'should C_UD a new product' do
        product_category = create(:product_category)
        product = create(:product, product_category:)
        expect(product).to be_valid
        expect(product.product_inventory.quantity).to eq(0)

        product.name = 'New name'
        product.description = 'New description'

        product.save

        expect(product.name).to eq('New name')
        expect(product.description).to eq('New description')

        product.destroy
        expect(product.persisted?).to be_falsey
        expect(product.product_inventory.persisted?).to be_falsey
      end
    end
  end
end
