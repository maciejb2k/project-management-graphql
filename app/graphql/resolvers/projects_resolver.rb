# frozen_string_literal: true

module Resolvers
  class ProjectsResolver < Resolvers::BaseResolver
    description "Get all projects"

    type Types::ProjectType.connection_type, null: false

    argument :query, Inputs::RansackInputFactory.build(:project), required: false, description: "Search query"

    def resolve(query: nil)
      authorize_by_access_header!

      current_user
        .projects
        .lazy_preload(tasks: :comments)
        .ransack(query.to_h)
        .result(distinct: true)
    end
  end
end
