# frozen_string_literal: true

module Mutations
  RSpec.describe ChangeTaskStatusMutation, type: :request do
    context "when user is not authenticated" do
      let(:query) { create_query(project_id: 1, id: 1, status: "done") }

      include_examples "returns an error when user is not authenticated"
    end

    context "when user is authenticated" do
      let!(:user) { create(:user) }
      let!(:tokens) { sign_in(user) }

      context "when the request is valid" do
        let!(:project) { create(:project, user:) }
        let!(:task) { create(:task, project:, status: "doing") }
        let!(:valid_query) { create_query(project_id: project.id, id: task.id, status: "done") }

        it "updates a task" do
          post "/api/graphql", params: { query: valid_query }, headers: auth_headers(tokens)

          expect(task.reload).to have_attributes(
            status: "done"
          )
        end

        it "returns a task" do
          post "/api/graphql", params: { query: valid_query }, headers: auth_headers(tokens)
          json = JSON.parse(response.body)
          data = json["data"]["changeTaskStatus"]

          expect(data["errors"]).to be_empty
          expect(data["task"]).to include(
            "id" => task.id.to_s,
            "status" => "done"
          )
        end
      end

      context "when the request is invalid" do
        context "when the id is invalid" do
          let!(:project) { create(:project, user:) }
          let!(:task) { create(:task, project:, status: "todo") }
          let!(:valid_query) { create_query(project_id: project.id, id: task.id, status: "done") }

          before do
            task.destroy
          end

          it "returns an error" do
            expect do
              post "/api/graphql", params: { query: valid_query }, headers: auth_headers(tokens)
            end.to raise_error(ActiveRecord::RecordNotFound)
          end
        end

        context "when the status is invalid" do
          let!(:project) { create(:project, user:) }
          let!(:task) { create(:task, project:, status: "todo") }
          let!(:valid_query) { create_query(project_id: project.id, id: task.id, status: "invalid") }

          it "returns an error" do
            post "/api/graphql", params: { query: valid_query }, headers: auth_headers(tokens)
            json = JSON.parse(response.body)
            data = json["errors"][0]["message"]

            expect(data).to include("has an invalid value")
          end
        end
      end
    end

    def create_query(project_id:, id:, status: "todo")
      <<~GQL
        mutation {
          changeTaskStatus(input: { projectId: #{project_id}, id: #{id}, status: #{status} }) {
            task {
              id
              status
            }
            errors
          }
        }
      GQL
    end
  end
end
