# frozen_string_literal: true

# == Schema Information
#
# Table name: accounts
#
#  id          :uuid             not null, primary key
#  name        :string
#  slug        :string
#  users_count :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_accounts_on_slug  (slug) UNIQUE
#
require 'rails_helper'

RSpec.describe Account, type: :model do
  it 'has a valid factory' do
    expect(create(:account)).to be_valid
  end

  # Validations
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_length_of(:name).is_at_most(255) }
end
