# frozen_string_literal: true

module Mutations
  class RefreshMutation < BaseMutation
    description "Refresh session with JWT token"

    field :token, Types::JwtType, null: false

    def resolve
      authorize_by_refresh_header!

      session = JWTSessions::Session.new(payload:)

      { token: session.refresh(found_token) }
    end
  end
end
