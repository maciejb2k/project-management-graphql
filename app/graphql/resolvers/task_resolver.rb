# frozen_string_literal: true

module Resolvers
  class TaskResolver < Resolvers::BaseResolver
    description "Get task by ID"

    type Types::TaskType, null: false

    argument :project_id, ID, required: true, description: "Project ID"
    argument :id, ID, required: true, description: "ID of the task"

    def resolve(project_id:, id:)
      authenticate_user!

      project = policy_scope(Project).find(project_id)

      policy_scope(project.tasks)
        .find(id)
    end
  end
end
