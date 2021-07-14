# frozen_string_literal: true

module Mutations
  module Users
    # Accepts an invitation for a user
    class AcceptInvite < Mutations::BaseMutation
      description 'Accepts an invitation for a user'
      argument :invitation_token, String, required: true
      argument :attributes, Types::Users::UserInputType, required: true
      payload_type Boolean

      def resolve(invitation_token:, attributes:)
        user = User.accept_invitation!(attributes.to_h.merge(invitation_token: invitation_token))
        raise ActiveRecord::RecordInvalid, user unless user.errors.empty?

        true
      end
    end
  end
end
