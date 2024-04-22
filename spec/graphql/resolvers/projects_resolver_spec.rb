# frozen_string_literal: true

module Resolvers
  RSpec.describe ProjectsResolver, type: :request do
    context "when user is not authenticated" do
      let(:query) { create_query }

      include_examples "returns an error when user is not authenticated"
    end

    context "when user is authenticated" do
      let!(:user) { create(:user) }
      let!(:tokens) { sign_in(user) }

      context "when request is without parameters" do
        let!(:projects) { create_list(:project, 3, user:) }
        let!(:valid_query) { create_query }

        it "returns all projects" do
          post "/api/graphql", params: { query: valid_query }, headers: auth_headers(tokens)

          json = JSON.parse(response.body)
          data = json["data"]["projects"]["nodes"]

          response_ids = data.map { |project| project["id"] }
          project_ids = projects.map(&:id).map(&:to_s)

          expect(response_ids).to match_array(project_ids) # `match_array` doesn't care about order - no flaky test!
        end
      end

      context "when request is with filtering" do
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

        before { create_list(:project, 3) }

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

      context "when user belongs to multiple projects" do
        let!(:projects) { create_list(:project, 3, user:) }
        let!(:other_project) { create(:project, user: create(:user)) }
        let!(:valid_query) { create_query }

        before do
          # Create extra projects the user doesn't belong to
          create_list(:project, 3)

          # Assign current user to the other project
          create(:project_member, project: other_project, user:, role: "owner")
        end

        it "returns only the projects the user belongs to" do
          post "/api/graphql", params: { query: valid_query }, headers: auth_headers(tokens)
          json = JSON.parse(response.body)
          data = json["data"]["projects"]["nodes"]

          response_ids = data.map { |project| project["id"] }
          project_ids = projects.map(&:id).map(&:to_s) + [other_project.id.to_s]

          expect(response_ids.size).to eq(4)
          expect(response_ids).to match_array(project_ids)
        end
      end

      context "when the user doesn't belong to any project" do
        let!(:valid_query) { create_query }

        before { create_list(:project, 3) }

        it "doesn't return any projects" do
          post "/api/graphql", params: { query: valid_query }, headers: auth_headers(tokens)
          json = JSON.parse(response.body)
          data = json["data"]["projects"]["nodes"]

          expect(data).to be_empty
        end
      end
    end

    def create_query
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
  end
end
