# frozen_string_literal: true

class TaskPolicy < ApplicationPolicy
  def create?
    member? && permission?(:create, :task)
  end

  def read?
    member? && permission?(:read, :task)
  end

  def update?
    member? && permission?(:update, :task)
  end

  def delete?
    member? && permission?(:delete, :task)
  end

  def status_change?
    member? && permission?(:status_change, :task)
  end

  private

  def member?
    record.project.members.include?(user)
  end
end
