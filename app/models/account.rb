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
class Account < ApplicationRecord
  validates :name, presence: true
  validates :name, length: { maximum: 255 }
  has_many :users, dependent: :destroy

  # :nocov:
  rails_admin do
    weight 10
    navigation_icon 'fa fa-building'

    list do
      field :id
      field :name
      field :users_count
    end

    edit do
      field :name
    end

    show do
      field :id
      field :name
      field :users_count
    end
  end

  # :nocov:
end
