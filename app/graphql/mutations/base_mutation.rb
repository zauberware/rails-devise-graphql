# frozen_string_literal: true

module Mutations
  # Base mutation class for app
  class BaseMutation < GraphQL::Schema::Mutation
    def current_ability
      Ability.new(context[:current_user])
    end
  end
end
