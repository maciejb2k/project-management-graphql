# frozen_string_literal: true

module Mutations
  RSpec.describe DeleteTaskMutation, type: :request do
    context "when user is not authenticated" do
      let(:query) { create_query(id: 1) }

      include_examples "returns an error when user is not authenticated"
    end

    context "when user is authenticated" do
      let!(:user) { create(:user) }
      let!(:tokens) { sign_in(user) }

      context "when the request is valid" do
        let!(:project) { create(:project, user:) }
        let!(:task) { create(:task, project:) }
        let!(:valid_query) { create_query(id: task.id) }

        it "deletes a task" do
          expect do
            post "/api/graphql", params: { query: valid_query }, headers: auth_headers(tokens)
          end.to change(Task, :count).by(-1)
        end

        it "returns a success message" do
          post "/api/graphql", params: { query: valid_query }, headers: auth_headers(tokens)
          json = JSON.parse(response.body)
          data = json["data"]["deleteTask"]

          expect(data).to include(
            "success" => true,
            "errors" => []
          )
        end
      end

      context "when the request is invalid" do
        context "when the id is invalid" do
          let!(:project) { create(:project, user:) }
          let!(:invalid_query) { create_query(id: "invalid_id") }

          it "returns an graphql error" do
            post "/api/graphql", params: { query: invalid_query }, headers: auth_headers(tokens)
            json = JSON.parse(response.body)
            error = json["errors"][0]["message"]

            expect(error).to include "has an invalid value"
          end
        end

        context "when the id is already deleted" do
          let!(:project) { create(:project, user:) }
          let!(:task) { create(:task, project:) }
          let!(:valid_query) { create_query(id: task.id) }

          before do
            task.destroy
          end

          it "returns an error" do
            expect do
              post "/api/graphql", params: { query: valid_query }, headers: auth_headers(tokens)
            end.to raise_error(ActiveRecord::RecordNotFound)
          end
        end
      end
    end

    def create_query(id:)
      <<~GQL
        mutation {
          deleteTask(input: { id: #{id} }) {
            success
            errors
          }
        }
      GQL
    end
  end
end
