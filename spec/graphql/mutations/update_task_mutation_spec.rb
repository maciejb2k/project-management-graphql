module Mutations
  RSpec.describe UpdateTaskMutation, type: :request do
    describe "#resolve" do
      context "when the request is valid" do
        let!(:task) { create(:task, title: "task to rename") }

        it "updates a task" do
          post "/graphql", params: { query: query(id: task.id, title: "renamed", status: "done") }
          json = JSON.parse(response.body)
          data = json["data"]["updateTask"]["task"]

          expect(task.reload).to have_attributes(
            title: "renamed",
            status: "done"
          )
        end
      end

      context "when the request is invalid" do
        it "returns an error" do
          skip "Implement this test"
        end
      end
    end

    def query(id:, title: "Task 1", status: "todo")
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
