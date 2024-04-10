# frozen_string_literal: true

module Mutations
  class CreateProjectMutation < Mutations::BaseMutation
    description "Create a new project"

    argument :attributes, Inputs::ProjectInput, required: true

    field :project, Types::ProjectType, null: true
    field :errors, [String], null: true

    def resolve(attributes:)
      authorize_by_access_header!

      project = current_user.projects.build(attributes.to_h)

      if project.save
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
