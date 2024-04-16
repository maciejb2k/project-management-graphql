# frozen_string_literal: true

class ProjectMemberPolicy < ApplicationPolicy
  def create?
    project_owner?
  end

  def destroy?
    project_owner? || project_member?
  end

  private

  def project_owner?
    user == record.project.owner
  end

  def project_member?
    record.project.members.include?(user)
  end
end
