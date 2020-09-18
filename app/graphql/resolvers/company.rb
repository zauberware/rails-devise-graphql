# frozen_string_literal: true

module Resolvers
  # Resolver to return a user
  class Company < BaseResolver
    type Types::CompanyType, null: true
    description 'Returns the company for the user.'

    def resolve
      context[:current_user] ? context[:current_user].company : nil
    end
  end
end
