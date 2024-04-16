# frozen_string_literal: true

class AddRoleIndexToProjectMembers < ActiveRecord::Migration[7.0]
  def change
    add_index :project_members, %i[project_id user_id role], unique: true, where: "role = 'owner'"
  end
end
