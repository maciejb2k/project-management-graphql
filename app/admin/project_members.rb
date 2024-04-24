# frozen_string_literal: true

ActiveAdmin.register ProjectMember do
  menu parent: "Resources"

  form do |f|
    f.inputs do
      input :project, as: :searchable_select
      input :user, as: :searchable_select
      input :role, as: :select, collection: ProjectMember::ROLES
    end

    f.actions
  end

  permit_params :project_id, :user_id, :role
end
