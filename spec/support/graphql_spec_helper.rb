module GraphqlSpecHelper

  def graphql!
    GraphqlSchema.execute(
      @query,
      context: @context,
      variables: @variables
    )
  end

  def prepare_query_variables(variables)
    @variables = variables
  end

  def prepare_context(context)
    @context = context
  end

  def prepare_query(query)
    @query = query
  end

end