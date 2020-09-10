# frozen_string_literal: true

# Entry point for graphql schema
class GraphqlSchema < GraphQL::Schema
  query(Types::QueryType)
  mutation(Types::MutationType)
end
