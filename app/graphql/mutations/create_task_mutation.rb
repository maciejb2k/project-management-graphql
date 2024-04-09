# frozen_string_literal: true

module Mutations
  class CreateTaskMutation < Mutations::BaseMutation
    description "Create a new task"

    argument :attributes, Inputs::TaskInput, required: true

    field :task, Types::TaskType, null: true
    field :errors, [String], null: true

    def resolve(attributes:)
      task = Task.new(attributes.to_h)

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
