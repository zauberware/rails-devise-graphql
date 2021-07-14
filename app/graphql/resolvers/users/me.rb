# frozen_string_literal: true

module Resolvers
  module Users
    # Get current user object
    class Me < Resolvers::BaseResolver
      type Types::Users::UserType, null: true
      description 'Returns the current user'

      def resolve
        context[:current_user]
      end
    end
  end
end
