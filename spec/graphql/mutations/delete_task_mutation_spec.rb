module Mutations
  RSpec.describe CreateTaskMutation, type: :request do
    describe "#resolve" do
      context "when the request is valid" do
        let!(:task) { create(:task) }

        it "deletes a task" do
          expect do
            post "/graphql", params: { query: query(id: task.id) }
          end.to change(Task, :count).by(-1)
        end

        it "returns a success message" do
          post "/graphql", params: { query: query(id: task.id) }
          json = JSON.parse(response.body)
          data = json["data"]["deleteTask"]

          expect(data).to include(
            "success" => true,
            "errors" => []
          )
        end
      end

      context "when the request is invalid" do
        it "returns an error" do
          skip "Implement this test"
        end
      end
    end

    def query(id:)
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
