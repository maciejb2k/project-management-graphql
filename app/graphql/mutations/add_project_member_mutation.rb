# frozen_string_literal: true

module Mutations
  class AddProjectMemberMutation < BaseMutation
    description "Add a new member to a project"

    argument :project_id, ID, required: true
    argument :user_id, ID, required: true
    argument :role, Types::RoleEnum, required: true

    field :project_member, Types::ProjectMemberType, null: true
    field :errors, [String], null: true

    def resolve(project_id:, user_id:, role:)
      authenticate_user!

      project = Project.find(project_id)
      user = User.find(user_id)
      project_member = project.project_members.build(user:, role:)

      authorize project_member, :create?

      if project_member.save
        {
          project_member:,
          errors: []
        }
      else
        {
          project_member: nil,
          errors: project_member.errors.full_messages
        }
      end
    end
  end
end
