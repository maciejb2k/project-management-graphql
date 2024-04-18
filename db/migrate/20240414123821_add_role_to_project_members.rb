# frozen_string_literal: true

class AddRoleToProjectMembers < ActiveRecord::Migration[7.0]
  def change
    add_column :project_members, :role, :string, null: false, default: ProjectMember::ROLES.first
  end
end
