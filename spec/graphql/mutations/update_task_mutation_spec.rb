# frozen_string_literal: true

module Mutations
  RSpec.describe UpdateTaskMutation, type: :request do
    describe "#resolve" do
      context "when the request is valid" do
        let!(:task) { create(:task, title: "task to rename") }
        let!(:valid_query) { update_query(id: task.id, title: "renamed", status: "done") }

        it "updates a task" do
          post "/graphql", params: { query: valid_query }

          expect(task.reload).to have_attributes(
            title: "renamed",
            status: "done"
          )
        end

        it "returns a task" do
          post "/graphql", params: { query: valid_query }
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
          let!(:task) { create(:task, title: "task to rename") }
          let!(:valid_query) { update_query(id: task.id, title: "renamed", status: "done") }

          before do
            task.destroy
          end

          it "returns an error" do
            post "/graphql", params: { query: valid_query }
            json = JSON.parse(response.body)
            error = json["errors"][0]["message"]

            expect(error).to include "UpdateTaskMutationPayload not found"
          end
        end
      end
    end

    def update_query(id:, title: "Task 1", status: "todo")
      <<~GQL
        mutation {
          updateTask(input: { id: #{id}, attributes: { title: "#{title}", status: "#{status}" }}) {
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
