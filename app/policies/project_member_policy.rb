# frozen_string_literal: true

class ProjectMemberPolicy < ApplicationPolicy
  def create?
    user_is_owner?
  end

  # Rules explanation:
  # - Project owner can remove project members except themselves.
  # - Project members can remove themselves from the project.
  def destroy?
    user_is_owner_but_not_self? || user_is_not_owner_but_self?
  end

  private

  def user_is_owner?
    ProjectPolicy.new(user, record.project).owner?
  end

  def user_is_self?
    user == record.user
  end

  def user_is_owner_but_not_self?
    user_is_owner? && !user_is_self?
  end

  def user_is_not_owner_but_self?
    !user_is_owner? && user_is_self?
  end
end
