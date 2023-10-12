# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  describe 'validations' do
    it { is_expected.to have_db_column(:item_cost).of_type(:decimal) }
    it { is_expected.to have_db_column(:order_id).of_type(:integer) }
    it { is_expected.to have_db_column(:product_id).of_type(:integer) }
    it { is_expected.to have_db_column(:quantity).of_type(:integer) }
    it { should belong_to(:order) }
    it { should validate_presence_of(:quantity) }
  end
end
