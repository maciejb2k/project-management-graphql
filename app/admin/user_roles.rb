# frozen_string_literal: true

ActiveAdmin.register UserRole do
  menu parent: "Authorization"

  permit_params :role_id, :user_id
end
