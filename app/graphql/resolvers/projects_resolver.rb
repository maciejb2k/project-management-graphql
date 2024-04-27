# frozen_string_literal: true

module Resolvers
  class ProjectsResolver < Resolvers::BaseResolver
    description "Get all projects"

    type Types::ProjectType.connection_type, null: false

    argument :query, Inputs::RansackInputFactory.build(:project), required: false, description: "Search query"

    def resolve(query: nil)
      authenticate_user!

      policy_scope(Project)
        .lazy_preload(:project_members, tasks: :comments)
        .ransack(query)
        .result(distinct: true)
    end
  end
end
