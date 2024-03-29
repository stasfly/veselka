# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
    it { is_expected.to have_db_column(:email).of_type(:string).with_options(default: '', null: false) }
    it { is_expected.to have_db_column(:encrypted_password).of_type(:string).with_options(default: '', null: false) }
    it { is_expected.to have_db_column(:reset_password_token).of_type(:string) }
    it { is_expected.to have_db_column(:reset_password_sent_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime).with_options(precision: 6, null: false) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime).with_options(precision: 6, null: false) }
    it { is_expected.to have_db_index(:email).unique(true) }
    it 'creates valid user' do
      expect(create(:user)).to be_valid
      expect { create(:user) }.to change(User, :count).by(1)
    end

    context 'does not creates invalid user' do
      let(:invalid_user) do
        { email: 'no_at_at_all.com',
          password: Faker::Internet.password(min_length: 6),
          password_confirmation: '' }
      end

      let(:user) { build(:user, invalid_user) }

      it { expect(user).not_to be_valid }
      it { expect { user.save }.to change(User, :count).by(0) }
    end
  end

  describe 'associations' do
    it { should have_many(:orders) }
    it { should have_one(:cart).dependent(:destroy) }
  end
end
