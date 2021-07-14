# frozen_string_literal: true

module Mutations
  # Creates a new resource.
  class CreateMutationBase < Mutations::BaseMutation
    def resolve(attributes:)
      raise CanCan::AccessDenied, 'access denied' if context[:current_user].nil?

      resource = resources.new(attributes.to_h)
      current_ability.authorize! :create, resource
      return resource if resource.save!
    end

    protected

    def resources
      # return a ActiveRecord relation for this mutation
      raise 'Not implemented'
    end
  end
end
