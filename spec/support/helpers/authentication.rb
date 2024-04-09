# frozen_string_literal: true

module Helpers
  module Authentication
    def sign_in_raw(user)
      post "/api/graphql", params: { query: sign_in_query(email: user.email, password: user.password) }
      JSON.parse(response.body)
    end

    def sign_in(user)
      json = sign_in_raw(user)
      json["data"]["signIn"]["token"].symbolize_keys
    end

    def sign_out_raw(headers)
      post "/api/graphql", headers:, params: { query: sign_out_query }
      JSON.parse(response.body)
    end

    def sign_out(headers)
      json = sign_out_raw(headers)
      json["data"]["signOut"]
    end

    def refresh_jwt_raw(headers)
      post "/api/graphql", headers:, params: { query: refresh_query }
      JSON.parse(response.body)
    end

    def refresh_jwt(headers)
      json = refresh_jwt_raw(headers)
      json["data"]["refresh"]["token"].symbolize_keys
    end

    def auth_headers(tokens)
      {
        "Authorization": "Bearer #{tokens[:access]}",
        "X-Refresh-Token": tokens[:refresh]
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

    def refresh_query
      <<~GQL
        mutation {
          refresh(input: {}) {
            token {
              access
              accessExpiresAt
            }
          }
        }
      GQL
    end
  end
end
