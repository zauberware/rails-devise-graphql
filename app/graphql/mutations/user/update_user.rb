# frozen_string_literal: true

module Mutations
  module User
    # Update user profile
    class UpdateUser < GraphQL::Schema::Mutation
      null true
      description 'Update user profile'
      argument :password, String, required: false
      argument :passwordConfirmation, String, required: false
      payload_type Types::UserType

      def resolve(
        password: context[:current_user] ? context[:current_user].password : '',
        password_confirmation: context[:current_user] ? context[:current_user].password_confirmation : ''
      )
        user = context[:current_user]
        return nil unless user

        user.update!(
          password: password,
          password_confirmation: password_confirmation
        )
        user
      end
    end
  end
end
