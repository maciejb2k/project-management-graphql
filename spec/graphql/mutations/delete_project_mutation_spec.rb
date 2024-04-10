# frozen_string_literal: true

module Mutations
  RSpec.describe DeleteProjectMutation, type: :request do
    describe "#resolve" do
      let!(:user) { create(:user) }
      let!(:tokens) { sign_in(user) }

      context "when the request is valid" do
        let!(:project) { create(:project, user:) }
        let!(:valid_query) { delete_query(id: project.id) }

        it "deletes a project" do
          expect do
            post "/api/graphql", params: { query: valid_query }, headers: auth_headers(tokens)
          end.to change(Project, :count).by(-1)
        end

        it "returns a success message" do
          post "/api/graphql", params: { query: valid_query }, headers: auth_headers(tokens)
          json = JSON.parse(response.body)
          data = json["data"]["deleteProject"]

          expect(data).to include(
            "success" => true,
            "errors" => []
          )
        end
      end

      context "when the request is invalid" do
        let!(:invalid_query) { delete_query(id: "xd") }

        it "returns an error" do
          post "/api/graphql", params: { query: invalid_query }, headers: auth_headers(tokens)
          json = JSON.parse(response.body)
          error = json["errors"][0]["message"]

          expect(error).to include "has an invalid value"
        end
      end

      context "when the project is already deleted" do
        let!(:project) { create(:project, user:) }
        let!(:valid_query) { delete_query(id: project.id) }

        before do
          project.destroy
        end

        it "returns an error" do
          expect do
            post "/api/graphql", params: { query: valid_query }, headers: auth_headers(tokens)
          end.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

    def delete_query(id:)
      <<~GQL
        mutation {
          deleteProject(input: { id: #{id} }) {
            success
            errors
          }
        }
      GQL
    end
  end
end
