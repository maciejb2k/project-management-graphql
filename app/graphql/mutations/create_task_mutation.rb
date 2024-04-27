# frozen_string_literal: true

module Mutations
  class CreateTaskMutation < Mutations::BaseMutation
    description "Create a new task"

    argument :project_id, ID, required: true
    argument :attributes, Inputs::TaskInput, required: true

    field :task, Types::TaskType, null: true
    field :errors, [String], null: true

    def resolve(project_id:, attributes:)
      authenticate_user!

      project = Project.find(project_id)
      task = project.tasks.build(attributes.to_h)

      authorize task, :create?

      if task.save
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
