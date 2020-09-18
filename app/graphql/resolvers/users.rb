# frozen_string_literal: true

module Resolvers
  # Resolver to return a user
  class Users < BaseResolver
    type Types::UserType.connection_type, null: true
    description 'Returns all user for the current user company'

    def resolve(**_args)
      ::User.accessible_by(current_ability).includes(:company)
    end
  end
end
