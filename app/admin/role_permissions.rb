# frozen_string_literal: true

ActiveAdmin.register RolePermission do
  menu parent: "Authorization"

  form do |f|
    f.inputs do
      input :role, as: :searchable_select
      input :permission, as: :searchable_select
    end

    f.actions
  end

  permit_params :role_id, :permission_id
end
