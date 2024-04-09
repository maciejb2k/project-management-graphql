# frozen_string_literal: true

module Types
  class JwtType < Types::BaseObject
    field :csrf, String, null: false
    field :access, String, null: false
    field :access_expires_at, GraphQL::Types::ISO8601DateTime, null: false
    field :refresh, String, null: false
    field :refresh_expires_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
