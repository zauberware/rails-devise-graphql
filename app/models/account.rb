# frozen_string_literal: true

# == Schema Information
#
# Table name: accounts
#
#  id         :uuid             not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Account < ApplicationRecord
  validates :name, presence: true
  validates :name, length: { maximum: 255 }
  has_many :users, dependent: :destroy
end
