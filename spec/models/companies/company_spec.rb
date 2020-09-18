# frozen_string_literal: true

# == Schema Information
#
# Table name: companies
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
#  index_companies_on_slug  (slug) UNIQUE
#
require 'rails_helper'

RSpec.describe Companies::Company, type: :model do
  it 'has a valid factory' do
    expect(create(:company)).to be_valid
  end

  # Validations
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_length_of(:name).is_at_most(255) }
end
