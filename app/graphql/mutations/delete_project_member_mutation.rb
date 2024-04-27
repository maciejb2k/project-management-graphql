# frozen_string_literal: true

module Mutations
  class DeleteProjectMemberMutation < BaseMutation
    description "Add a new member to a project"

    argument :project_id, ID, required: true
    argument :user_id, ID, required: true

    field :success, Boolean, null: true
    field :errors, [String], null: true

    def resolve(project_id:, user_id:)
      authenticate_user!

      project = Project.find(project_id)
      project_member = project.project_members.find_by!(user_id:)
      authorize project_member, :destroy?

      if project_member.destroy
        {
          success: true,
          errors: []
        }
      else
        {
          success: false,
          errors: project_member.errors.full_messages
        }
      end
    end
  end
end
