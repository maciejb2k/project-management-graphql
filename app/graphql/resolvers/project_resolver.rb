# frozen_string_literal: true

module Resolvers
  class ProjectResolver < BaseResolver
    description "Get project by ID"

    type Types::ProjectType, null: false

    argument :id, ID, required: true, description: "ID of the project"

    def resolve(id:)
      authenticate_user!

      policy_scope(Project)
        .lazy_preload(tasks: :comments)
        .find(id)
    end
  end
end
