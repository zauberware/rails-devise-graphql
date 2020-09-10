# frozen_string_literal: true

module Mutations
  module User
    # JWT token login
    class TokenLogin < GraphQL::Schema::Mutation
      null true
      description 'JWT token login'
      payload_type Types::UserType

      def resolve
        context[:current_user]
      end
    end
  end
end
