# frozen_string_literal: true

module Mutations
  # Base resolver to delete a resource.
  class DeleteMutationBase < Mutations::BaseMutation
    argument :id, ID, required: true
    payload_type Boolean

    def resolve(id:)
      raise CanCan::AccessDenied, 'access denied' if context[:current_user].nil?

      resource = resources.find_by(id: id)
      if resource.nil?
        raise ActiveRecord::RecordNotFound,
              I18n.t('errors.resource_not_found', resource: resources.model.model_name.human)
      end

      current_ability.authorize! :destroy, resource
      resource.destroy!
      true
    end

    protected

    def resources
      # return a ActiveRecord relation for this mutation
      raise 'Not implemented'
    end
  end
end
