# frozen_string_literal: true

module Resolvers
  RSpec.describe ProjectsResolver, type: :request do
    describe "API requests" do
      let!(:user) { create(:user) }
      let!(:tokens) { sign_in(user) }

      describe "request without parameters" do
        let!(:projects) { create_list(:project, 3, user:) }
        let!(:valid_query) do
          <<~GQL
            query {
              projects {
                nodes {
                  id
                }
              }
            }
          GQL
        end

        it "returns all projects" do
          post "/api/graphql", params: { query: valid_query }, headers: auth_headers(tokens)
          json = JSON.parse(response.body)
          data = json["data"]["projects"]["nodes"]

          response_ids = data.map { |project| project["id"] }
          project_ids = projects.map(&:id).map(&:to_s)

          expect(response_ids).to match_array(project_ids) # `match_array` doesn't care about order - no flaky test!
        end
      end

      describe "request with filtering" do
        before { create_list(:project, 3) }

        let!(:project) { create(:project, title: "project to find", user:) }
        let!(:valid_query) do
          <<~GQL
            query {
              projects(query: { title_eq: "project to find" }) {
                nodes {
                  id
                }
              }
            }
          GQL
        end

        it "returns the filtered projects" do
          post "/api/graphql", params: { query: valid_query }, headers: auth_headers(tokens)
          json = JSON.parse(response.body)
          data = json["data"]["projects"]["nodes"]

          response_project = data.first["id"]
          expected_project = project.id.to_s

          expect(data.size).to eq(1)
          expect(response_project).to eq(expected_project)
        end
      end
    end
  end
end
