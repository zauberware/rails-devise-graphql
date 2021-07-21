# frozen_string_literal: true

module Mutations
  module Users
    # Updates an existing user as an admin.
    class UpdateUser < Mutations::UpdateMutationBase
      description 'Updates an existing m2 case.'
      argument :attributes, Types::Users::UserInputType, required: true
      payload_type Types::Users::UserType

      protected

      def resources
        ::User.accessible_by(current_ability)
      end
    end
  end
end
