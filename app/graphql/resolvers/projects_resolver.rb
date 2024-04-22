# frozen_string_literal: true

module Resolvers
  class ProjectsResolver < Resolvers::BaseResolver
    description "Get all projects"

    type Types::ProjectType.connection_type, null: false

    argument :query, Inputs::RansackInputFactory.build(:project), required: false, description: "Search query"

    def resolve(query: nil)
      authenticate_user!

      Project
        .joins(:project_members)
        .where(project_members: { user: current_user })
        .lazy_preload(:project_members, tasks: :comments)
        .ransack(query.to_h)
        .result(distinct: true)
    end
  end
end
