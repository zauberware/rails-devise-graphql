# frozen_string_literal: true

module Mutations
  module Users
    # Updates an existing user as an admin.
    class UpdateUser < Mutations::BaseMutation
      description 'Updates an existing user as an admin.'
      argument :id, ID, required: true
      argument :attributes, Types::Users::UserInputType, required: true
      payload_type Types::Users::UserType

      def resolve(id:, attributes:)
        user = ::User.accessible_by(current_ability).find_by(id: id)
        if user.nil?
          raise ActiveRecord::RecordNotFound,
                I18n.t('errors.messages.resource_not_found', resource: ::User.model_name.human)
        end

        user.attributes = attributes.to_h
        current_ability.authorize! :update, user
        return user if user.save!
      end
    end
  end
end
