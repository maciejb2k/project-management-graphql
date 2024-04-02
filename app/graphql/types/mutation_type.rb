# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :create_task, mutation: Mutations::CreateTaskMutation
    field :update_task, mutation: Mutations::UpdateTaskMutation
    field :delete_task, mutation: Mutations::DeleteTaskMutation
  end
end
