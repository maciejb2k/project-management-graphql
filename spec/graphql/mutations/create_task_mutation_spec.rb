module Mutations
  RSpec.describe CreateTaskMutation, type: :request do
    describe "#resolve" do
      context "when the request is valid" do
        it "creates a task" do
          expect do
            post "/graphql", params: { query: query }
          end.to change(Task, :count).by(1)
        end

        it "returns a task" do
          post "/graphql", params: { query: query }
          json = JSON.parse(response.body)
          data = json["data"]["createTask"]["task"]

          expect(data).to include(
            "id" => be_present,
            "title" => "Task 1",
            "status" => "todo"
          )
        end
      end

      context "when the request is invalid" do
        it "returns an error" do
          post "/graphql", params: { query: query(title: "", status: "") }
          json = JSON.parse(response.body)
          errors = json["data"]["createTask"]["errors"]

          expect(errors).to be_present
          expect(errors).to include("Title can't be blank")
          expect(errors).to include("Status can't be blank")
        end
      end
    end

    def query(title: "Task 1", status: "todo")
      <<~GQL
        mutation {
          createTask(input: { attributes: { title: "#{title}", status: "#{status}" }}) {
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
