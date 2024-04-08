# frozen_string_literal: true

class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.integer :estimated_time
      t.integer :delivered_time
      t.string :status, null: false, default: Task::STATUS_OPTIONS.first
      t.timestamps
    end
  end
end
