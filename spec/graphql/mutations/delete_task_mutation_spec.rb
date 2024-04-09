# frozen_string_literal: true

module Mutations
  RSpec.describe CreateTaskMutation, type: :request do
    describe "#resolve" do
      context "when the request is valid" do
        let!(:task) { create(:task) }
        let!(:valid_query) { delete_query(id: task.id) }

        it "deletes a task" do
          expect do
            post "/api/graphql", params: { query: valid_query }
          end.to change(Task, :count).by(-1)
        end

        it "returns a success message" do
          post "/api/graphql", params: { query: valid_query }
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
          let!(:invalid_query) { delete_query(id: "invalid_id") }

          it "returns an error" do
            post "/api/graphql", params: { query: invalid_query }
            json = JSON.parse(response.body)
            error = json["errors"][0]["message"]

            expect(error).to include "has an invalid value"
          end
        end

        context "when the id is already deleted" do
          let!(:task) { create(:task) }
          let!(:valid_query) { delete_query(id: task.id) }

          before do
            task.destroy
          end

          it "returns an error" do
            post "/api/graphql", params: { query: valid_query }
            json = JSON.parse(response.body)
            error = json["errors"][0]["message"]

            expect(error).to include "DeleteTaskMutationPayload not found"
          end
        end
      end
    end

    def delete_query(id:)
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
