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
    permission?(:create, :task)
  end

  def read?
    permission?(:read, :task)
  end

  def update?
    permission?(:update, :task)
  end

  def delete?
    permission?(:delete, :task)
  end

  def status_change?
    permission?(:status_change, :task)
  end
end
