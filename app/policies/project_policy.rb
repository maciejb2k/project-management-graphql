# frozen_string_literal: true

class ProjectPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.joins(:project_members).where(project_members: { user: })
    end
  end

  def create?
    owner?
  end

  def read?
    owner? || member?
  end

  def update?
    owner?
  end

  def delete?
    owner?
  end

  def owner?
    user == record.owner
  end

  def member?
    record.members.include?(user)
  end
end
