# frozen_string_literal: true

module Mutations
  class ChangeTaskStatusMutation < Mutations::BaseMutation
    description "Change the status of a task"

    argument :project_id, ID, required: true
    argument :id, ID, required: true
    argument :status, Types::TaskStatusEnum, required: true

    field :task, Types::TaskType, null: true
    field :errors, [String], null: true

    def resolve(project_id:, id:, status:)
      authenticate_user!

      project = current_user.projects.find(project_id)

      authorize project, :read?

      task = project.tasks.find(id)

      authorize task, :status_change?

      if task.change_status!(status)
        {
          task:,
          errors: []
        }
      else
        {
          task: nil,
          errors: task.errors.full_messages
        }
      end
    end
  end
end
