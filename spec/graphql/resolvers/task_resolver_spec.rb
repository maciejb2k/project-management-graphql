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
          post "/graphql", params: { query: valid_query }

          json = JSON.parse(response.body)
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
          post "/graphql", params: { query: invalid_query }
          json = JSON.parse(response.body)
          error = json["errors"][0]["message"]

          expect(error).to include "Task not found"
        end
      end
    end
  end
end
