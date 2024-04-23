# frozen_string_literal: true

class ProjectPolicy < ApplicationPolicy
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

  private

  def owner?
    user == record.owner
  end

  def member?
    record.members.include?(user)
  end
end
