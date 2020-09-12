# frozen_string_literal: true

module Types
  # GraphQL type for a user
  class AccountType < BaseModel
    field :name, String, null: false
  end
end
