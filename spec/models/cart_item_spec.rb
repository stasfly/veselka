# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CartItem, type: :model do
  describe 'CartItem validations' do
    it { is_expected.to have_db_column(:cart_id).of_type(:integer) }
    it { is_expected.to have_db_column(:product_id).of_type(:integer) }
    it { is_expected.to have_db_column(:quantity).of_type(:integer) }
    it { should belong_to(:cart) }
    it { should belong_to(:product) }
  end
end
