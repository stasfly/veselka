# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Cart, type: :model do
  describe 'validations' do
    it { is_expected.to have_db_column(:user_id).of_type(:integer) }
    it { should belong_to(:user) }
    it { should have_many(:cart_items).dependent(:delete_all) }
  end

  describe 'create/destroy behaviour' do
    let(:user) { create(:user) }
    let(:cart) { user.cart }
    # Create test
    it 'should create a new cart' do
      expect(cart).to be_valid
      expect(cart.user).to eq(user)
    end

    # Destroy test
    it 'should destroy a cart' do
      user.destroy

      expect(cart.persisted?).to be_falsey
    end

    # `has_many` association test
    it 'should have a `has_many` association with the `CartItem` model' do
      product_category = create(:product_category)
      product1 = create(:product, product_category:)
      product2 = create(:product, product_category:)
      expect(cart.cart_items).to be_empty

      cart_item1 = create(:cart_item, cart:, product: product1)
      cart_item2 = create(:cart_item, cart:, product: product2)

      expect(cart.cart_items).to contain_exactly(cart_item1, cart_item2)
      user.destroy
      expect(cart.cart_items).to be_empty
    end
  end
end
