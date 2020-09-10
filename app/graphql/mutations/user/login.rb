# frozen_string_literal: true

module Mutations
  module User
    # Login for users
    class Login < GraphQL::Schema::Mutation
      null true
      description 'Login for users'
      argument :email, String, required: true
      argument :password, String, required: true
      payload_type Types::UserType

      def resolve(email:, password:)
        user = ::User.find_for_authentication(email: email)
        return nil unless user

        is_valid_for_auth = user.valid_for_authentication? do
          user.valid_password?(password)
        end
        is_valid_for_auth ? user : nil
      end
    end
  end
end
