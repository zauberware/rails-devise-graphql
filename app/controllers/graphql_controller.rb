# frozen_string_literal: true

# GraphQL API entry point
class GraphqlController < ApplicationController
  # Executes the graphql request
  def execute
    query, variables, operation_name = read_query_params()
    context = set_context()
    result = GraphqlSchema.execute(
      query,
      variables: variables,
      context: context,
      operation_name: operation_name
    )
    render json: result
  rescue StandardError => e
    raise e unless Rails.env.development?

    handle_error_in_development e
  end

  private

  def read_query_params
    [
      params[:query],
      ensure_hash(params[:variables]),
      params[:operationName]
    ]
  end

  def set_context
    {
      current_user: current_user
      # login: method(:sign_in)
    }
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

  def handle_error_in_development(err)
    logger.error err.message
    logger.error err.backtrace.join("\n")

    render json: {
      error: {
        message: err.message,
        backtrace: err.backtrace
      },
      data: {}
    }, status: 500
  end
end
