# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :sign_in, mutation: Mutations::SignInMutation
    field :sign_out, mutation: Mutations::SignOutMutation
    field :refresh, mutation: Mutations::RefreshMutation

    field :create_project, mutation: Mutations::CreateProjectMutation
    field :update_project, mutation: Mutations::UpdateProjectMutation
    field :delete_project, mutation: Mutations::DeleteProjectMutation

    field :create_task, mutation: Mutations::CreateTaskMutation
    field :update_task, mutation: Mutations::UpdateTaskMutation
    field :delete_task, mutation: Mutations::DeleteTaskMutation
  end
end
