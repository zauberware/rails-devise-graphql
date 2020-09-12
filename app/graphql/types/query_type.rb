# frozen_string_literal: true

module Types
  # Loads queries into schema
  # include other queries and resolvers here
  class QueryType < BaseObject
    field :me, resolver: Resolvers::Me

    field :users, Types::UserType.connection_type, null: false
    def users(**_args)
      ::User.accessible_by(current_ability)
    end
    field :user, resolver: Resolvers::User

    def current_ability
      Ability.new(context[:current_user])
    end
  end
end
