# frozen_string_literal: true

class CreatePermissions < ActiveRecord::Migration[7.0]
  def change
    create_table :permissions do |t|
      t.string :action, null: false
      t.string :resource, null: false

      t.timestamps
    end

    add_index :permissions, %i[action resource], unique: true
  end
end
