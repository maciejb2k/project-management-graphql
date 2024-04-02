# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :tasks, resolver: Resolvers::TasksResolver, null: false
    field :task, resolver: Resolvers::TaskResolver, null: false
  end
end
