# frozen_string_literal: true

module Resolvers
  class TasksResolver < Resolvers::BaseResolver
    description "Get all tasks"

    type Types::TaskType.connection_type, null: false

    argument :project_id, ID, required: true, description: "Project ID"
    argument :query, GraphQL::Types::JSON, required: false, description: "Search query"

    def resolve(project_id:, query: nil)
      authorize_by_access_header!

      current_user
        .projects
        .find(project_id)
        .tasks
        .lazy_preload(:comments)
        .ransack(query)
        .result(distinct: true)
    end
  end
end
