# frozen_string_literal: true

module Mutations
  class DeleteTaskMutation < Mutations::BaseMutation
    description "Delete a task"

    argument :id, ID, required: true

    field :success, Boolean, null: false
    field :errors, [String], null: false

    def resolve(id:)
      task = Task.find(id)

      if task.destroy
        {
          success: true,
          errors: []
        }
      else
        {
          success: false,
          errors: playlist.errors.full_messages
        }
      end
    end
  end
end
