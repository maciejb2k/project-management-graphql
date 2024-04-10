# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    # Projects
    field :projects, resolver: Resolvers::ProjectsResolver, null: false
    field :project, resolver: Resolvers::ProjectResolver, null: false

    # Tasks
    field :tasks, resolver: Resolvers::TasksResolver, null: false
    field :task, resolver: Resolvers::TaskResolver, null: false
  end
end
