# frozen_string_literal: true

module Mutations
  class DeleteProjectMutation < Mutations::BaseMutation
    description "Delete a project"

    argument :id, ID, required: true

    field :success, Boolean, null: false
    field :errors, [String], null: false

    def resolve(id:)
      authenticate_user!

      project = current_user.projects.find(id)

      authorize project, :delete?

      if project.destroy
        {
          success: true,
          errors: []
        }
      else
        {
          success: false,
          errors: project.errors.full_messages
        }
      end
    end
  end
end
