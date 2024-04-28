# frozen_string_literal: true

ActiveAdmin.register UserRole do
  menu parent: "Authorization"

  includes :user, :role

  form do |f|
    f.inputs do
      input :user, as: :searchable_select
      input :role, as: :searchable_select
    end

    f.actions
  end

  permit_params :role_id, :user_id
end
