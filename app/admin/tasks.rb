# frozen_string_literal: true

ActiveAdmin.register Task do
  menu parent: "Resources"

  includes :project

  permit_params :title, :estimated_time, :delivered_time, :status, :project_id

  form do |f|
    f.inputs do
      input :project, as: :searchable_select
      input :title
      input :estimated_time
      input :delivered_time
      input :status, as: :select, collection: Task::STATUS_OPTIONS
    end

    f.actions
  end

  filter :title
  filter :estimated_time
  filter :delivered_time
  filter :status, as: :select, collection: Task::STATUS_OPTIONS
end
