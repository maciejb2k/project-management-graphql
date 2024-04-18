# frozen_string_literal: true

class ProjectMemberPolicy < ApplicationPolicy
  def create?
    user == record.project.owner
  end

  def destroy?
    return true if user == record.project.owner && user != record.user
    return true if user != record.project.owner && user == record.user

    false
  end
end
