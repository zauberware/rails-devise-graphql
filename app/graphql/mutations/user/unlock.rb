# frozen_string_literal: true

module Mutations
  module User
    # Unlock the user account
    class Unlock < GraphQL::Schema::Mutation
      null false
      description 'Unlock the user account'
      argument :unlockToken, String, required: true
      payload_type Boolean

      def resolve(unlock_token:)
        user = ::User.unlock_access_by_token(unlock_token)
        user.id
      end
    end
  end
end
