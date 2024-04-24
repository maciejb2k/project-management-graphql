# frozen_string_literal: true

ActiveAdmin.register Permission do
  menu parent: "Authorization"

  permit_params :action, :resource
end
