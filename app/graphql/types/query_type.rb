module Types
  class QueryType < BaseObject
    field :me, resolver: Resolvers::Me
  end
end
  