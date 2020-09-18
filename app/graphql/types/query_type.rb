# frozen_string_literal: true

module Types
  # Loads queries into schema
  # include other queries and resolvers here
  class QueryType < BaseObject
    field :me, resolver: Resolvers::Users::Me

    field :users, resolver: Resolvers::Users::Users
    field :user, resolver: Resolvers::Users::User

    field :company, resolver: Resolvers::Companies::Company
  end
end
