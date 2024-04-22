# frozen_string_literal: true

module Mutations
  class UpdateProjectMutation < Mutations::BaseMutation
    description "Update a project"

    argument :id, ID, required: true
    argument :attributes, Inputs::ProjectInput, required: true

    field :project, Types::ProjectType, null: true
    field :errors, [String], null: true

    def resolve(id:, attributes:)
      authenticate_user!

      project = current_user.projects.find(id)

      if project.update(attributes.to_h)
        {
          project:,
          errors: []
        }
      else
        {
          project: nil,
          errors: project.errors.full_messages
        }
      end
    end
  end
end
