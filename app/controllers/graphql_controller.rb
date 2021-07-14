# frozen_string_literal: true

# GraphQL API entry point
class GraphqlController < ApplicationController
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
      if ambiguous_param.present?
        ensure_hash(JSON.parse(ambiguous_param))
      else
        {}
      end
    when Hash, ActionController::Parameters
      ambiguous_param
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{ambiguous_param}"
    end
  end

  def handle_error(err)
    render json: {
      error: {
        message: err.message,
        backtrace: (Rails.env.development? ? err.backtrace : 'not provided')
      },
      data: {}
    }, status: :internal_server_error
  end
end
