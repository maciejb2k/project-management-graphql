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

      unless project.save
        return {
          project: nil,
          errors: project.errors.full_messages
        }
      end

      project.project_members.create(user: current_user, role: "owner")

      {
        project:,
        errors: []
      }
    end
  end
end
