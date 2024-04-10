# frozen_string_literal: true

module Mutations
  RSpec.describe UpdateTaskMutation, type: :request do
    describe "#resolve" do
      let!(:user) { create(:user) }
      let!(:tokens) { sign_in(user) }

      context "when the request is valid" do
        let!(:project) { create(:project, user:) }
        let!(:task) { create(:task, project:, title: "task to rename") }
        let!(:valid_query) { update_query(project_id: project.id, id: task.id, title: "renamed", status: "done") }

        it "updates a task" do
          post "/api/graphql", params: { query: valid_query }, headers: auth_headers(tokens)

          expect(task.reload).to have_attributes(
            title: "renamed",
            status: "done"
          )
        end

        it "returns a task" do
          post "/api/graphql", params: { query: valid_query }, headers: auth_headers(tokens)
          json = JSON.parse(response.body)
          data = json["data"]["updateTask"]

          expect(data["errors"]).to be_empty
          expect(data["task"]).to include(
            "id" => task.id.to_s,
            "title" => "renamed",
            "status" => "done"
          )
        end
      end

      context "when the request is invalid" do
        context "when the id is invalid" do
          let!(:project) { create(:project, user:) }
          let!(:task) { create(:task, project:, title: "task to rename") }
          let!(:valid_query) { update_query(project_id: project.id, id: task.id, title: "renamed", status: "done") }

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

    def update_query(project_id:, id:, title: "Task 1", status: "todo")
      <<~GQL
        mutation {
          updateTask(input: { projectId: #{project_id}, id: #{id}, attributes: { title: "#{title}", status: "#{status}" }}) {
            task {
              id
              title
              status
            }
            errors
          }
        }
      GQL
    end
  end
end
