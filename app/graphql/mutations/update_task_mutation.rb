# frozen_string_literal: true

module Mutations
  class UpdateTaskMutation < Mutations::BaseMutation
    description 'Update a task'

    argument :id, ID, required: true
    argument :attributes, Inputs::TaskInput, required: true

    field :task, Types::TaskType, null: true
    field :errors, [String], null: true

    def resolve(id:, attributes:)
      task = Task.find(id)

      if task.update(attributes.to_h)
        {
          task: task,
          errors: [],
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
