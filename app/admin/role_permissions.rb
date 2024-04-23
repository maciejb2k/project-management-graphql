# frozen_string_literal: true

ActiveAdmin.register RolePermission do
  menu parent: "Authorization"

  permit_params :role_id, :permission_id
end
