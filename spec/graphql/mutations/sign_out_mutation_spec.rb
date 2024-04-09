# frozen_string_literal: true

module Mutations
  RSpec.describe SignOutMutation, type: :request do
    describe "#resolve" do
      context "when user is not authenticated" do
        context "when headers are not present" do
          it "throws an exception" do
            expect do
              post "/api/graphql", params: { query: sign_out_query }
            end.to raise_error(JWTSessions::Errors::Unauthorized)
          end
        end

        context "when access token is invalid" do
          it "throws an exception" do
            headers = {
              "Authorization": "Bearer invalid_token"
            }

            expect do
              post "/api/graphql", headers:, params: { query: sign_out_query }
            end.to raise_error(JWTSessions::Errors::Unauthorized)
          end
        end

        context "when access token encoding is invalid" do
          it "throws an exception" do
            headers = {
              "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"
            }

            expect do
              post "/api/graphql", headers:, params: { query: sign_out_query }
            end.to raise_error(JWTSessions::Errors::Unauthorized)
          end
        end
      end

      context "when user is authenticated" do
        let!(:user) { create(:user) }
        let!(:tokens) { sign_in(user) }

        it "signs out the user" do
          post "/api/graphql", headers: auth_headers(tokens), params: { query: sign_out_query }
          json = JSON.parse(response.body)
          data = json["data"]["signOut"]

          expect(response).to have_http_status(:ok)
          expect(data).to include("success" => true)
        end
      end
    end
  end
end
