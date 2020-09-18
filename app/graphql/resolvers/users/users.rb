# frozen_string_literal: true

module Resolvers
  module Users
    # Resolver to return a user
    class Users < Resolvers::BaseResolver
      type Types::Users::UserType.connection_type, null: true
      description 'Returns all user for the current user company'

      def resolve(**_args)
        ::User.accessible_by(current_ability).includes(:company)
      end
    end
  end
end
