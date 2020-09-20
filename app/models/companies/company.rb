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
module Companies
  # A company to scope a bunch of users
  class Company < ApplicationRecord
    extend FriendlyId

    self.table_name = 'companies'

    # - EXTENSIONS
    friendly_id :name, use: :slugged

    # - VALIDATIONS
    validates :name, presence: true
    validates :name, length: { maximum: 255 }
    validates :slug, length: { maximum: 255 }

    # - RELATIONS
    has_many :users, dependent: :destroy

    # override friendly id checker for categories
    def should_generate_new_friendly_id?
      (slug.nil? || slug.blank?) || (name_changed? && !slug_changed?)
    end

    # :nocov:
    rails_admin do
      weight 10
      navigation_icon 'fa fa-building'

      list do
        field :id
        field :name
        field :slug
        field :users_count
      end

      edit do
        field :name
        field :slug
      end

      show do
        field :id
        field :name
        field :slug
        field :users_count
      end
    end

    # :nocov:
  end
end
