# frozen_string_literal: true

ActiveAdmin.register Project do
  menu parent: "Resources"

  includes :user

  permit_params :title, :description, :start_date, :end_date, :is_deleted, :user_id

  form do |f|
    f.inputs do
      input :user, as: :searchable_select
      input :title
      input :description
      input :start_date, as: :date_time_picker
      input :end_date, as: :date_time_picker
    end

    f.actions
  end

  filter :title
  filter :description
  filter :created_at, as: :date_time_range
  filter :updated_at, as: :date_time_range

  actions :all, except: []
end
