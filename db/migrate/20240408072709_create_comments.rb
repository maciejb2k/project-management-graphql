# frozen_string_literal: true

class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.text :content, null: false, default: ""
      t.timestamps
    end

    add_reference :comments, :task, foreign_key: true, null: false # rubocop:disable Rails/NotNullColumn
    add_reference :comments, :user, foreign_key: true, null: false # rubocop:disable Rails/NotNullColumn
  end
end
