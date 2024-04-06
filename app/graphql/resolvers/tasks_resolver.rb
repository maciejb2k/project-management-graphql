# frozen_string_literal: true

module Resolvers
  class TasksResolver < Resolvers::BaseResolver
    description 'Get all tasks'

    type Types::TaskType.connection_type, null: false

    argument :query, GraphQL::Types::JSON, required: false, description: 'Search query'

    def resolve(query: nil)
      ::Task.ransack(query).result(distinct: true)
    end
  end
end
