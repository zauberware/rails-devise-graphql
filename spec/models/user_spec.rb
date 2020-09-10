# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it 'has a valid factory' do
    expect(create(:user)).to be_valid
    expect(create(:user, :customer)).to be_valid
    expect(create(:user, :admin)).to be_valid
  end

  # Validations
  it { is_expected.to validate_presence_of(:first_name) }
  it { is_expected.to validate_length_of(:first_name).is_at_most(255) }
  it { is_expected.to validate_presence_of(:last_name) }
  it { is_expected.to validate_length_of(:last_name).is_at_most(255) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_length_of(:email).is_at_most(255) }
  it { is_expected.to allow_value('email@address.foo').for(:email) }
  it { is_expected.not_to allow_value('email').for(:email) }
  it { is_expected.not_to allow_value('email@domain').for(:email) }
  it { is_expected.not_to allow_value('email@domain.').for(:email) }
  it { is_expected.not_to allow_value('email@domain.a').for(:email) }

  # Callbacks
  describe '#setup_new_user' do
    let(:user) { build(:user) }

    it 'sets role to customer' do
      expect(user.role).to eq 'customer'
    end
  end

  # Methods
  describe '#name' do
    it 'returns first and lastname' do
      expect(create(:user, first_name: 'A', last_name: 'B').name).to eq 'A B'
    end
  end
end
