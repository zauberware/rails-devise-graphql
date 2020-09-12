# frozen_string_literal: true

module Resolvers
  # Base resolver class
  class BaseResolver < GraphQL::Schema::Resolver
    def current_ability
      Ability.new(context[:current_user])
    end
  end
end
