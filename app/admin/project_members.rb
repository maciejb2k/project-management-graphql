# frozen_string_literal: true

ActiveAdmin.register ProjectMember do
  menu parent: "Resources"

  permit_params :project_id, :user_id, :role
end
