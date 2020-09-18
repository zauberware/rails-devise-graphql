# frozen_string_literal: true

GraphQL::Errors.configure(GraphqlSchema) do
  rescue_from ActiveRecord::RecordNotFound do |_exception|
    nil
  end

  rescue_from CanCan::AccessDenied do |exception|
    GraphQL::ExecutionError.new(exception.message)
  end

  rescue_from ActiveRecord::RecordInvalid do |exception|
    GraphQL::ExecutionError.new(exception.record.errors.full_messages.join("\n"))
  end

  # rescue_from StandardError do |exception|
  #   GraphQL::ExecutionError.new("Please try to execute the query for this field later")
  # end

  # rescue_from CustomError do |exception, object, arguments, context|
  #   error = GraphQL::ExecutionError.new("Error found!")
  #   firstError.path = context.path + ["myError"]
  #   context.add_error(firstError)
  # end
end
