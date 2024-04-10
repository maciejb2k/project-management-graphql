# frozen_string_literal: true

module Mutations
  RSpec.describe RefreshMutation, type: :request do
    describe "#resolve" do
      let!(:user) { create(:user) }
      let!(:tokens) { sign_in(user) }

      context "when refresh token is valid" do
        it "returns new access token" do
          data = refresh_jwt(auth_headers(tokens))

          expect(response).to have_http_status(:ok)
          expect(data).to include(:access, :accessExpiresAt)
        end
      end

      context "when refresh token is invalid" do
        it "returns an error" do
          headers = { "X-Refresh-Token": "invalid_token" }

          expect do
            refresh_jwt(headers)
          end.to raise_error(JWTSessions::Errors::Unauthorized)
        end
      end
    end
  end
end
