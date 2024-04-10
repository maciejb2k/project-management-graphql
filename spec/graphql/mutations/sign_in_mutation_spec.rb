# frozen_string_literal: true

module Mutations
  RSpec.describe SignInMutation, type: :request do
    describe "#resolve" do
      context "when the request is valid" do
        let!(:user) { create(:user) }
        let!(:valid_query) { sign_in_query(email: user.email, password: user.password) }

        it "signs in a user" do
          post "/api/graphql", params: { query: valid_query }
          json = JSON.parse(response.body)
          data = json["data"]["signIn"]
          token = data["token"]

          expect(token).to be_present
          expect(token).to include(
            "access",
            "accessExpiresAt",
            "refresh",
            "refreshExpiresAt"
          )
        end
      end

      context "when the request is invalid" do
        context "when the email is invalid" do
          let!(:invalid_query) { sign_in_query(email: "invalid_email", password: "password") }

          it "returns an error" do
            post "/api/graphql", params: { query: invalid_query }
            json = JSON.parse(response.body)
            error = json["errors"][0]["message"]

            expect(error).to include "Invalid email or password"
          end
        end

        context "when the password is invalid" do
          let!(:user) { create(:user) }
          let!(:invalid_query) { sign_in_query(email: user.email, password: "invalid_password") }

          it "returns an error" do
            post "/api/graphql", params: { query: invalid_query }
            json = JSON.parse(response.body)
            error = json["errors"][0]["message"]

            expect(error).to include "Invalid email or password"
          end
        end
      end
    end
  end
end
