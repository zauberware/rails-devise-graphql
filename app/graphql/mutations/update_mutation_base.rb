# frozen_string_literal: true

module Mutations
  # Base mutation for all updates.
  class UpdateMutationBase < Mutations::BaseMutation
    argument :id, ID, required: true
    # argument :attributes, Types::Assets::AssetInputType, required: true
    # payload_type Types::Assets::AssetType

    def resolve(id:, attributes:)
      raise CanCan::AccessDenied, 'access denied' if context[:current_user].nil?

      resource = resources.find_by(id: id)
      if resource.nil?
        raise ActiveRecord::RecordNotFound,
              I18n.t('errors.resource_not_found', resource: resources.model.model_name.human)
      end

      resource.attributes = attributes.to_h
      current_ability.authorize! :update, resource
      return resource if resource.save!
    end

    protected

    def resources
      # return a ActiveRecord relation for this mutation
      raise 'Not implemented'
    end
  end
end
