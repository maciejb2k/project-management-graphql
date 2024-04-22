# frozen_string_literal: true

module Helpers
  module Authorization
    include Pundit::Authorization

    def current_user
      context[:current_user]
    end

    def authenticate_user!
      raise GraphQL::ExecutionError, "You need to sign in or sign up before continuing." unless current_user
    end

    # Available only if authenticated with Doorkeeper

    def doorkeeper_token
      context[:doorkeeper_token]
    end

    def doorkeeper_scopes
      doorkeeper_token&.scopes&.to_a
    end
  end
end
