# frozen_string_literal: true

module Mutations
  module Users
    # Updates the role for an user as an admin.
    class UpdateUserRole < Mutations::BaseMutation
      description 'Updates the role for an user as an admin.'
      argument :id, ID, required: true
      argument :role, String, required: true, description: '"user" or "admin"'
      payload_type Boolean

      def resolve(id:, role:)
        user = ::User.accessible_by(current_ability).find_by(id: id)
        if user.nil?
          raise ActiveRecord::RecordNotFound,
                I18n.t('errors.messages.resource_not_found', resource: ::User.model_name.human)
        end

        if %w[admin user].include?(role)
          user.role = role
          current_ability.authorize! :update, user
          user.save!
          return true
        end

        false
      end
    end
  end
end
