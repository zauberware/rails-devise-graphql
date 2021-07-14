# frozen_string_literal: true

module Resolvers
  # Base resolver class include everything you need for sorting and filtering entities
  class BaseResolver < GraphQL::Schema::Resolver
    # return a ActiveRecord relation for this mutation
    def resources
      raise 'Not implemented'
    end

    def current_ability
      Ability.new(context[:current_user])
    end
  end
end
