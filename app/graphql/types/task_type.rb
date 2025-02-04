# frozen_string_literal: true

module Types
  class TaskType < Types::BaseObject
    field :id, ID, null: false
    field :title, String, null: false
    field :estimated_time, Integer
    field :delivered_time, Integer
    field :status, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :project, Types::ProjectType, null: false
    field :comments, [Types::CommentType], null: false
  end
end
