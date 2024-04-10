# frozen_string_literal: true

module Resolvers
  RSpec.describe TaskResolver, type: :request do
    describe "API requests" do
      let!(:user) { create(:user) }
      let!(:token) { sign_in(user) }

      describe "request with valid id" do
        let!(:project) { create(:project, user:) }
        let!(:task) { create(:task, project:) }
        let!(:valid_query) do
          <<~GQL
            query {
              task(projectId: #{project.id}, id: #{task.id}) {
                id
              }
            }
          GQL
        end

        it "returns the task" do
          post "/api/graphql", params: { query: valid_query }, headers: auth_headers(token)
          json = JSON.parse(response.body)
          data = json["data"]["task"]

          expect(data).to eq("id" => task.id.to_s)
        end
      end

      describe "request with invalid id" do
        let!(:project) { create(:project, user:) }
        let!(:task) { create(:task, project:) }
        let!(:invalid_query) do
          <<~GQL
            query {
              task(projectId: #{project.id}, id: #{task.id}) {
                id
              }
            }
          GQL
        end

        before do
          task.destroy
        end

        it "returns an error" do
          expect do
            post "/api/graphql", params: { query: invalid_query }, headers: auth_headers(token)
          end.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end
end
