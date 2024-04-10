# frozen_string_literal: true

module Mutations
  class SignInMutation < BaseMutation
    description "Sign in a user"

    argument :email, String, required: true
    argument :password, String, required: true

    field :token, Types::JwtType, null: false

    def resolve(email:, password:)
      user = User.find_by(email:)

      raise GraphQL::ExecutionError, "Invalid email or password" unless user&.authenticate(password)

      payload = { user_id: user.id }
      session = JWTSessions::Session.new(payload:, refresh_by_access_allowed: true)

      { token: session.login }
    end
  end
end
