# frozen_string_literal: true

module Helpers
  module Authentication
    def sign_in(user)
      post "/oauth/token", params: {
        grant_type: "password",
        email: user.email,
        password: user.password,
        client_id: Doorkeeper::Application.first.uid,
        client_secret: Doorkeeper::Application.first.secret
      }
      json = JSON.parse(response.body)
      json.symbolize_keys
    end

    def auth_headers(tokens)
      {
        "Authorization": "Bearer #{tokens[:access_token]}"
      }
    end
  end
end
