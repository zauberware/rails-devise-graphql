# frozen_string_literal: true

module Resolvers
  module Companies
    # Resolver to return a user
    class Company < ::Resolvers::BaseResolver
      type Types::Companies::CompanyType, null: true
      description 'Returns the company for the user.'

      def resolve
        context[:current_user] ? context[:current_user].company : nil
      end
    end
  end
end
