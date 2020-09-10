# frozen_string_literal: true

module Mutations
  module User
    # Unlock the user account
    class ResendUnlockInstructions < GraphQL::Schema::Mutation
      null false
      description 'Unlock the user account'
      argument :email, String, required: true
      payload_type Boolean

      def resend_unlock_instructions(email:)
        user = ::User.find_by(email: email)
        return false unless user

        user.resend_unlock_instructions
      end
    end
  end
end
