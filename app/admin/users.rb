# frozen_string_literal: true

ActiveAdmin.register User do
  menu parent: "Users"

  permit_params :email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at

  filter :email
end
