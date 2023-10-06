# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProductInventory, type: :model do
  describe 'test ProductCategory model' do
    context 'check validations' do
      it { should belong_to(:product).dependent(:destroy) }
      it { is_expected.to have_db_column(:quantity).of_type(:integer) }
    end
  end
end
