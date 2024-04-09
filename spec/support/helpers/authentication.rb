# frozen_string_literal: true

module Helpers
  module Authentication
    def sign_in(user)
      post "/api/graphql", params: { query: sign_in_query(email: user.email, password: user.password) }
      json = JSON.parse(response.body)
      json["data"]["signIn"]["token"].symbolize_keys
    end

    def sign_out(headers)
      post "/api/graphql", headers:, params: { query: sign_out_query }
      json = JSON.parse(response.body)
      json["data"]["signOut"]
    end

    def auth_headers(token)
      {
        "Authorization": "Bearer #{token[:access]}",
        "X-Refresh-Token": token[:refresh]
      }
    end

    def sign_in_query(email:, password:)
      <<~GQL
        mutation {
          signIn(input: { email: "#{email}", password: "#{password}" }) {
            token {
              access
              accessExpiresAt
              refresh
              refreshExpiresAt
            }
          }
        }
      GQL
    end

    def sign_out_query
      <<~GQL
        mutation {
          signOut(input: {}) {
            success
          }
        }
      GQL
    end
  end
end
