# frozen_string_literal: true

module Mutations
  class DeleteTaskMutation < Mutations::BaseMutation
    description "Delete a task"

    argument :project_id, ID, required: true
    argument :id, ID, required: true

    field :success, Boolean, null: false
    field :errors, [String], null: false

    def resolve(project_id:, id:)
      authenticate_user!

      project = current_user.projects.find(project_id)
      authorize project, :read?

      task = project.tasks.find(id)
      authorize task, :delete?

      if task.destroy
        {
          success: true,
          errors: []
        }
      else
        {
          success: false,
          errors: task.errors.full_messages
        }
      end
    end
  end
end
