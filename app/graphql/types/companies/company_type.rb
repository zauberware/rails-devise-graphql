# frozen_string_literal: true

module Types
  module Companies
    # GraphQL type for a company
    class CompanyType < Types::BaseModel
      field :name, String, null: false
      field :slug, String, null: true
      # field :users, [::Types::UserType], null: true
    end
  end
end
