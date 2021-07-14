# frozen_string_literal: true

module Types
  # Base class for all graphql model objects
  class BaseModel < GraphQL::Schema::Object
    field :id, ID, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
