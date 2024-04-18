# frozen_string_literal: true

module Types
  class ProjectMemberType < Types::BaseObject
    field :id, ID, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :project, Types::ProjectType, null: false
    field :user, Types::UserType, null: false
    field :role, String, null: false
  end
end
