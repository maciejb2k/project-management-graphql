# frozen_string_literal: true

Rails.application.routes.draw do
  mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/api/graphql"

  namespace :api do
    post "/graphql", to: "graphql#execute"
  end
end
