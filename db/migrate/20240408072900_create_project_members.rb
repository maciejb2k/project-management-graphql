# frozen_string_literal: true

class CreateProjectMembers < ActiveRecord::Migration[7.0]
  def change
    create_table :project_members, &:timestamps
    add_reference :project_members, :project, foreign_key: true, null: false # rubocop:disable Rails/NotNullColumn
    add_reference :project_members, :user, foreign_key: true, null: false # rubocop:disable Rails/NotNullColumn
    add_index :project_members, %i[project_id user_id], unique: true
  end
end
