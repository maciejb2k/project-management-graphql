# frozen_string_literal: true

Rails.application.routes.draw do
  ActiveAdmin.routes(self)

  use_doorkeeper do
    skip_controllers :authorizations, :applications, :authorized_applications
  end

  devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config

  mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/api/graphql"

  namespace :api do
    post "/graphql", to: "graphql#execute"
  end
end
