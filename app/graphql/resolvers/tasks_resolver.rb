# frozen_string_literal: true

module Resolvers
  class TasksResolver < Resolvers::BaseResolver
    description "Get all tasks"

    type Types::TaskType.connection_type, null: false

    argument :project_id, ID, required: true, description: "Project ID"
    argument :query, Inputs::RansackInputFactory.build(:task), required: false, description: "Search query"

    def resolve(project_id:, query: nil)
      authenticate_user!

      project = policy_scope(Project).find(project_id)

      policy_scope(project.tasks)
        .lazy_preload(:comments)
        .ransack(query)
        .result(distinct: true)
    end
  end
end
