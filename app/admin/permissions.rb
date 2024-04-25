# frozen_string_literal: true

ActiveAdmin.register Permission do
  menu parent: "Authorization"

  includes :role, :permission

  permit_params :action, :resource
end
