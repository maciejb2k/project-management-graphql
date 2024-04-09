# frozen_string_literal: true

module Mutations
  class SignOutMutation < BaseMutation
    description "Sign out a user"

    field :success, Boolean, null: false

    def resolve
      authorize_by_access_header!

      session = JWTSessions::Session.new(payload:)
      session.flush_by_access_payload

      { success: true }
    end
  end
end
