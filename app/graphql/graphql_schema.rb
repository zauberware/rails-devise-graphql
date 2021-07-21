# frozen_string_literal: true

# Entry point for graphql schema
class GraphqlSchema < GraphQL::Schema
  disable_introspection_entry_points if Rails.env.production?
  query(Types::QueryType)
  mutation(Types::MutationType)

  rescue_from ActiveRecord::RecordNotFound do |err, _obj, _args, _ctx, _field|
    GraphQL::ExecutionError.new(err.message)
  end

  rescue_from ActiveRecord::RecordInvalid do |err, _obj, _args, _ctx, _field|
    GraphQL::ExecutionError.new(err.message)
  end

  rescue_from ActiveRecord::RecordNotDestroyed do |err, _obj, _args, _ctx, _field|
    GraphQL::ExecutionError.new(err.message)
  end

  rescue_from CanCan::AccessDenied do |err, _obj, _args, _ctx, _field|
    GraphQL::ExecutionError.new(err.message)
  end
end
