# frozen_string_literal: true

module Resolvers
  # Get current user object
  class Me < BaseResolver
    type Types::UserType, null: true
    description 'Returns the current user'

    def resolve
      context[:current_user]
    end
  end
end
