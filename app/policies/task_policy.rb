# frozen_string_literal: true

class TaskPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if permission?(:read, :task)
        scope.all
      else
        scope.none
      end
    end
  end

  def create?
    permission?(:create, :task) && project_member?
  end

  def read?
    permission?(:read, :task) && project_member?
  end

  def update?
    permission?(:update, :task) && project_member?
  end

  def delete?
    permission?(:delete, :task) && project_member?
  end

  def status_change?
    permission?(:status_change, :task) && project_member?
  end

  private

  def project_member?
    ProjectPolicy.new(user, record.project).member?
  end
end
