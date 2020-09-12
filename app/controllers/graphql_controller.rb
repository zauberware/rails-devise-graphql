# frozen_string_literal: true

# GraphQL API entry point
class GraphqlController < ApplicationController
  include Graphql::AuthHelper

  # disable forgery protection for API
  skip_before_action :verify_authenticity_token

  # Executes the graphql request
  def execute
    query, variables, operation_name = read_query_params()
    result = GraphqlSchema.execute(
      query,
      variables: variables,
      context: context,
      operation_name: operation_name
    )
    render json: result
  rescue StandardError => e
    handle_error e
  end

  private

  def read_query_params
    [
      params[:query],
      ensure_hash(params[:variables]),
      params[:operationName]
    ]
  end

  # Handle form data, JSON body, or a blank value
  def ensure_hash(ambiguous_param)
    case ambiguous_param
    when String
      ambiguous_param.present? ? ensure_hash(JSON.parse(ambiguous_param)) : {}
    when Hash, ActionController::Parameters
      ambiguous_param
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{ambiguous_param}"
    end
  end

  def handle_error(err)
    logger.error err.message
    logger.error err.backtrace.join("\n")

    render json: {
      errors: [
        { message: err.message }
      ],
      data: {}
    }, status: 500
  end
end
