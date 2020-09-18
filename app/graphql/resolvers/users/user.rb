# frozen_string_literal: true

module Resolvers
  module Users
    # Resolver to return a user
    class User < Resolvers::BaseResolver
      type Types::Users::UserType, null: true
      description 'Returns the user for a requested id'

      argument :id, ID, required: true

      def resolve(id:)
        ::User.accessible_by(current_ability).find_by(id: id)
      end
    end
  end
end
