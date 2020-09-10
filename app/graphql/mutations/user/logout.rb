# frozen_string_literal: true

module Mutations
  module User
    # Logout for users
    class Logout < GraphQL::Schema::Mutation
      null true
      description 'Logout for users'
      payload_type Boolean

      def resolve
        user = context[:current_user]
        if user
          user.update(jti: SecureRandom.uuid)
          return true
        end
        false
      end
    end
  end
end
