# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :create_project, mutation: Mutations::CreateProjectMutation
    field :update_project, mutation: Mutations::UpdateProjectMutation
    field :delete_project, mutation: Mutations::DeleteProjectMutation
    field :add_project_member, mutation: Mutations::AddProjectMemberMutation
    field :delete_project_member, mutation: Mutations::DeleteProjectMemberMutation

    field :create_task, mutation: Mutations::CreateTaskMutation
    field :update_task, mutation: Mutations::UpdateTaskMutation
    field :delete_task, mutation: Mutations::DeleteTaskMutation
    field :change_task_status, mutation: Mutations::ChangeTaskStatusMutation
  end
end
