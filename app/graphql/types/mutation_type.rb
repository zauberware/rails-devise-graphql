# frozen_string_literal: true

module Types
  # Loads mutations into schema
  # Include ither mutations here
  class MutationType < Types::BaseObject
    implements ::Types::GraphqlAuth

    # Mutations
    # field :login, mutation: Mutations::User::Login
  end
end
