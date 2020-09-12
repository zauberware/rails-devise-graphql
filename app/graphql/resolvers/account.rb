# frozen_string_literal: true

module Resolvers
  # Resolver to return a user
  class Account < BaseResolver
    type Types::AccountType, null: true
    description 'Returns the account for the user.'

    def resolve
      context[:current_user] ? context[:current_user].account : nil
    end
  end
end
