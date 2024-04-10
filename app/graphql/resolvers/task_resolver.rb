# frozen_string_literal: true

module Resolvers
  class TaskResolver < Resolvers::BaseResolver
    description "Get task by ID"

    type Types::TaskType, null: false

    argument :project_id, ID, required: true, description: "Project ID"
    argument :id, ID, required: true, description: "ID of the task"

    def resolve(project_id:, id:)
      authorize_by_access_header!

      projects = current_user.projects.find(project_id)
      projects.tasks.find(id)
    end
  end
end
