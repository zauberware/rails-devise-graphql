# frozen_string_literal: true

module Mutations
  module Users
    # Deletes an user as an admin.
    class DeleteUser < Mutations::DeleteMutationBase
      payload_type Boolean

      protected

      def resources
        ::User.accessible_by(current_ability)
      end
    end
  end
end
