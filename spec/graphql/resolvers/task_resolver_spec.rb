# frozen_string_literal: true

module Resolvers
  RSpec.describe TaskResolver, type: :request do
    context "when user is not authenticated" do
      let(:query) { create_query(project_id: 1, id: 1) }

      include_examples "returns an error when user is not authenticated"
    end

    context "when user is authenticated" do
      let!(:user) { create(:user) }
      let!(:token) { sign_in(user) }

      describe "request with valid id" do
        let!(:project) { create(:project, user:) }
        let!(:task) { create(:task, project:) }
        let!(:valid_query) { create_query(project_id: project.id, id: task.id) }

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
        let!(:invalid_query) { create_query(project_id: project.id, id: task.id) }

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

    def create_query(project_id:, id:)
      <<~GQL
        query {
          task(projectId: #{project_id}, id: #{id}) {
            id
          }
        }
      GQL
    end
  end
end
