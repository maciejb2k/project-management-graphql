# frozen_string_literal: true

ActiveAdmin.register Project do
  menu parent: "Resources"

  permit_params :title, :description, :start_date, :end_date, :is_deleted, :user_id

  form do |f|
    f.inputs do
      input :user, as: :searchable_select
      input :title
      input :description
      input :start_date
      input :end_date
    end

    f.actions
  end

  filter :title
  filter :description
  filter :created_at
  filter :updated_at

  actions :all, except: []
end
