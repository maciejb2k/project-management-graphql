# frozen_string_literal: true

ActiveAdmin.register Task do
  menu parent: "Resources"

  permit_params :title, :estimated_time, :delivered_time, :status, :project_id

  filter :title
  filter :estimated_time
  filter :delivered_time
  filter :status
end
