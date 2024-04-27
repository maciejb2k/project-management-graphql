# frozen_string_literal: true

module Mutations
  class DeleteTaskMutation < Mutations::BaseMutation
    description "Delete a task"

    argument :id, ID, required: true

    field :success, Boolean, null: false
    field :errors, [String], null: false

    def resolve(id:)
      authenticate_user!

      task = Task.find(id)
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
