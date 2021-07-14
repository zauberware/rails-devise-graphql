# frozen_string_literal: true

module Mutations
  module Users
    # Deletes an user as an admin.
    class DeleteUser < Mutations::BaseMutation
      description 'Deletes an user as an admin.'
      argument :id, ID, required: true
      payload_type Boolean

      def resolve(id:)
        user = ::User.accessible_by(current_ability).find_by(id: id)
        if user.nil?
          raise ActiveRecord::RecordNotFound,
                I18n.t('errors.messages.resource_not_found', resource: ::User.model_name.human)
        end

        current_ability.authorize! :destroy, user
        return true if user.destroy!

        false
      end
    end
  end
end
