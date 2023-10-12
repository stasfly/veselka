# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'test Order model' do
    context 'check validations' do
      it { should have_many(:order_items) }
      it { should belong_to(:user) }
      it { is_expected.to have_db_column(:cost).of_type(:float) }
    end

    context 'transaction' do
      it 'should be commited' do
        user = create(:user, :with_cart_item)
        order = create(:order, user:)
        expect(order).to be_valid
        expect(order.cost).to be > 0
      end
    end
  end
end
