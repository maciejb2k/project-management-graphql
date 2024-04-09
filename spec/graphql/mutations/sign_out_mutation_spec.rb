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

        context "when access token base64 encoding is invalid" do
          it "throws an exception" do
            headers = {
              "Authorization": "Bearer eyJhbG.eyJzdWIiOiIxwIiwibmFtZSI.SflKxwRJSMeKKk6yJV_adQssw5c"
            }

            expect do
              post "/api/graphql", headers:, params: { query: sign_out_query }
            end.to raise_error(JWTSessions::Errors::Unauthorized)
          end
        end

        context "when bad access token is provided" do
          it "throws an exception" do
            headers = {
              "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwidXNlcl9pZCI6MSwiaWF0IjoxNTE2MjM5MDIyfQ.2QaRdUNiOh4gCqyXFv4k6_pPEtdmBeUTO9FqexiXjKM"
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
          data = sign_out(auth_headers(tokens))

          expect(response).to have_http_status(:ok)
          expect(data).to include("success" => true)
        end
      end
    end
  end
end
