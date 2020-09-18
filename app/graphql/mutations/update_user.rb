# frozen_string_literal: true

module Mutations
  # Updates an existing user.
  class UpdateUser < Mutations::BaseMutation
    description 'Updates an existing user.'
    argument :id, ID, required: true
    argument :attributes, Types::UserInputType, required: true
    payload_type Types::UserType

    def resolve(id:, attributes:)
      user = ::User.accessible_by(current_ability).find_by(id: id)
      raise ActiveRecord::RecordNotFound, I18n.t('errors.messages.resource_not_found', resource: ::User.model_name.human) if user.nil?

      user.attributes = attributes.to_h
      current_ability.authorize! :update, user
      return user if user.save!
    end
  end
end
