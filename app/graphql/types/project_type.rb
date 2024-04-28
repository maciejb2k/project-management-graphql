# frozen_string_literal: true

module Types
  class ProjectType < Types::BaseObject
    field :id, ID, null: false
    field :title, String, null: false
    field :description, String
    field :start_date, GraphQL::Types::ISO8601Date
    field :end_date, GraphQL::Types::ISO8601Date
    field :is_deleted, Boolean
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :user, Types::UserType, null: false

    field :tasks, [Types::TaskType], null: true
    def tasks
      policy_scope(object.tasks)
    end

    field :members, [Types::UserType], null: false

    field :owner, Types::UserType, null: false
    delegate :owner, to: :object
  end
end
