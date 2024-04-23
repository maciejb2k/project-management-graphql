# frozen_string_literal: true

ActiveAdmin.register Role do
  menu parent: "Authorization"

  permit_params :name
end
