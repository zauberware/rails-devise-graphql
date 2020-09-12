# frozen_string_literal: true

# == Schema Information
#
# Table name: accounts
#
#  id          :uuid             not null, primary key
#  name        :string
#  users_count :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :account do
    name { 'My Company' }
  end
end
