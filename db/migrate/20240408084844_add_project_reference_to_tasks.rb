# frozen_string_literal: true

class AddProjectReferenceToTasks < ActiveRecord::Migration[7.0]
  def change
    add_reference :tasks, :project, null: false, foreign_key: true # rubocop:disable Rails/NotNullColumn
  end
end
