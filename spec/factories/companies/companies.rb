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
FactoryBot.define do
  factory :company, class: 'Companies::Company' do
    name { 'My Company' }
  end
end
