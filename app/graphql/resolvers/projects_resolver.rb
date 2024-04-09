# frozen_string_literal: true

module Resolvers
  class ProjectsResolver < Resolvers::BaseResolver
    description "Get all projects"

    type Types::ProjectType.connection_type, null: false

    argument :query, GraphQL::Types::JSON, required: false, description: "Search query"

    def resolve(query: nil)
      authorize_by_access_header!

      current_user.projects.ransack(query).result(distinct: true)
    end
  end
end
