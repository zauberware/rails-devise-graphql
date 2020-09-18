# frozen_string_literal: true

module Types
  # GraphQL type for a user
  class UserType < BaseModel
    field :name, String, null: false
    field :first_name, String, null: false
    field :last_name, String, null: false
    field :email, String, null: true
    field :company, Types::CompanyType, null: false
  end
end
