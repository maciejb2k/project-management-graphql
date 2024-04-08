# frozen_string_literal: true

class CreateProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :projects do |t|
      t.string :title, null: false, default: ""
      t.string :description
      t.date :start_date
      t.date :end_date
      t.boolean :is_deleted, default: false
      t.timestamps
    end

    add_reference :projects, :user, foreign_key: true, null: false # rubocop:disable Rails/NotNullColumn
  end
end
