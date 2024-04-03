# frozen_string_literal: true

module Mutations
  RSpec.describe CreateTaskMutation, type: :request do
    # Unit test approach
    describe "#resolve" do
      subject(:resolve) do
        described_class
          .new(object: nil, context: nil, field: nil)
          .resolve(attributes:)
      end

      let!(:attributes) { { title: "Task 1", status: "todo" } }

      it "creates a task" do
        expect { resolve }.to change(Task, :count).by(1)
      end

      it "returns a task" do
        expect(resolve[:errors]).to be_empty
        expect(resolve[:task]).to be_a(Task)
        expect(resolve[:task]).to have_attributes(
          title: "Task 1",
          status: "todo"
        )
      end
    end

    # Schema test approach
    describe "Schema requests" do
      context "when the request is valid" do
        let!(:valid_query) { create_query(title: "Task 1", status: "todo") }

        it "creates a task" do
          expect { TodoGraphqlSchema.execute(valid_query) }.to change(Task, :count).by(1)
        end

        it "returns a task" do
          result = TodoGraphqlSchema.execute(valid_query)
          task = result.dig "data", "createTask", "task"
          errors = result.dig "data", "createTask", "errors"

          expect(errors).to be_empty
          expect(task).to include(
            "title" => "Task 1",
            "status" => "todo"
          )
        end
      end

      context "when the request is invalid" do
        let!(:invalid_query) { create_query(title: "", status: "") }

        it "returns an validation error" do
          result = TodoGraphqlSchema.execute(invalid_query)
          errors = result.dig("data", "createTask", "errors")

          expect(errors).to be_present
          expect(errors).to include("Title can't be blank")
          expect(errors).to include("Status can't be blank")
        end
      end
    end

    # Integration test approach
    describe "API requests" do
      context "when the request is valid" do
        let!(:valid_query) { create_query(title: "Task 1", status: "todo") }

        it "creates a task" do
          expect do
            post "/graphql", params: { query: valid_query }
          end.to change(Task, :count).by(1)
        end

        it "returns a task" do
          post "/graphql", params: { query: valid_query }

          json = JSON.parse(response.body)
          task = json["data"]["createTask"]["task"]

          expect(task).to include(
            "title" => "Task 1",
            "status" => "todo"
          )
        end
      end

      context "when the request is invalid" do
        let!(:invalid_query) { create_query(title: "", status: "") }

        it "returns an validation error" do
          post "/graphql", params: { query: invalid_query }

          json = JSON.parse(response.body)
          errors = json["data"]["createTask"]["errors"]

          expect(errors).to be_present
          expect(errors).to include("Title can't be blank")
          expect(errors).to include("Status can't be blank")
        end
      end
    end

    def create_query(title: "Task 1", status: "todo")
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
