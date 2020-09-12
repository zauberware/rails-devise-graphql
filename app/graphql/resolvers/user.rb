# frozen_string_literal: true

module Resolvers
  # Resolver to return a user
  class User < BaseResolver
    type Types::UserType, null: true
    description 'Returns the user for a requested id'

    argument :id, ID, required: true

    def resolve(id:)
      ::User.accessible_by(current_ability).find_by(id: id)
    end
  end
end
