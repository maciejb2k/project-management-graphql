# frozen_string_literal: true

ActiveAdmin.register Project do
  menu parent: "Resources"

  permit_params :title, :description, :start_date, :end_date, :is_deleted, :user_id

  filter :title
  filter :description
  filter :created_at
  filter :updated_at

  actions :all, except: []
end
