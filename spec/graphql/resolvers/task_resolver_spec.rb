# frozen_string_literal: true

module Resolvers
  RSpec.describe TaskResolver, type: :request do
    describe "API requests" do
      describe "request with valid id" do
        let!(:task) { create(:task) }
        let!(:valid_query) do
          <<~GQL
            query {
              task(id: #{task.id}) {
                id
              }
            }
          GQL
        end

        it "returns the task" do
          json = fetch_task(valid_query)
          data = json["data"]["task"]

          expect(data).to eq("id" => task.id.to_s)
        end
      end

      describe "request with invalid id" do
        let!(:task) { create(:task) }
        let!(:invalid_query) do
          <<~GQL
            query {
              task(id: #{task.id}) {
                id
              }
            }
          GQL
        end

        before do
          task.destroy
        end

        it "returns an error" do
          json = fetch_task(invalid_query)
          error = json["errors"][0]["message"]

          expect(error).to include "Task not found"
        end
      end
    end

    def fetch_task(query)
      post "/api/graphql", params: { query: }
      JSON.parse(response.body)
    end
  end
end
