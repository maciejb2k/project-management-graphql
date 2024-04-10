# frozen_string_literal: true

module Mutations
  RSpec.describe CreateTaskMutation, type: :request do
    describe "#resolve" do
      let!(:user) { create(:user) }
      let!(:tokens) { sign_in(user) }

      context "when the request is valid" do
        let!(:project) { create(:project, user:) }
        let!(:task) { create(:task, project:) }
        let!(:valid_query) { delete_query(project_id: project.id, id: task.id) }

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
          let!(:invalid_query) { delete_query(project_id: project.id, id: "invalid_id") }

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
          let!(:valid_query) { delete_query(project_id: project.id, id: task.id) }

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

    def delete_query(project_id:, id:)
      <<~GQL
        mutation {
          deleteTask(input: { projectId: #{project_id}, id: #{id} }) {
            success
            errors
          }
        }
      GQL
    end
  end
end
