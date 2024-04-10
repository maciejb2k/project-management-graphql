# frozen_string_literal: true

module Resolvers
  RSpec.describe TasksResolver, type: :request do
    describe "API requests" do
      let!(:user) { create(:user) }
      let!(:token) { sign_in(user) }

      describe "request without parameters" do
        let!(:project) { create(:project, user:) }
        let!(:tasks) { create_list(:task, 3, project:) }
        let!(:valid_query) do
          <<~GQL
            query {
              tasks(projectId: "#{project.id}") {
                nodes {
                  id
                }
              }
            }
          GQL
        end

        it "returns all tasks" do
          post "/api/graphql", params: { query: valid_query }, headers: auth_headers(token)
          json = JSON.parse(response.body)
          data = json["data"]["tasks"]["nodes"]

          response_ids = data.map { |task| task["id"] }
          tasks_ids = tasks.map(&:id).map(&:to_s)

          expect(response_ids).to match_array(tasks_ids)
        end
      end

      describe "request with filtering" do
        let!(:project) { create(:project, user:) }
        let!(:task) { create(:task, title: "task to find", project:) }
        let!(:valid_query) do
          <<~GQL
            query {
              tasks(projectId: "#{project.id}", query: { title_eq: "task to find" }) {
                nodes {
                  id
                }
              }
            }
          GQL
        end

        before { create_list(:task, 3, project:) }

        it "returns the filtered tasks" do
          post "/api/graphql", params: { query: valid_query }, headers: auth_headers(token)
          json = JSON.parse(response.body)
          data = json["data"]["tasks"]["nodes"]

          response_task = data.first["id"]
          expected_task = task.id.to_s

          expect(response_task).to eq(expected_task)
        end
      end

      describe "request with sorting" do
        let!(:project) { create(:project, user:) }
        let!(:valid_query) do
          <<~GQL
            query {
              tasks(projectId: "#{project.id}", query: { s: "title desc" }) {
                nodes {
                  id
                  title
                }
              }
            }
          GQL
        end

        before { %w[a b c].map { |title| create(:task, project:, title:) } }

        it "returns the sorted tasks" do
          post "/api/graphql", params: { query: valid_query }, headers: auth_headers(token)
          json = JSON.parse(response.body)
          data = json["data"]["tasks"]["nodes"]

          response_titles = data.map { |task| task["title"] }
          expected_titles = %w[c b a]

          expect(response_titles).to eq(expected_titles)
        end
      end

      describe "request with connection pagination" do
        let!(:project) { create(:project, user:) }
        let!(:tasks) { create_list(:task, 4, project:) }
        let!(:first_query) do
          <<~GQL
            query {
              tasks(projectId: #{project.id}, first: 2) {
                pageInfo {
                  startCursor
                  endCursor
                  hasNextPage
                  hasPreviousPage
                }
                edges{
                  cursor
                  node {
                    id
                  }
                }
              }
            }
          GQL
        end

        it "returns connection metadata" do
          post "/api/graphql", params: { query: first_query }, headers: auth_headers(token)
          json = JSON.parse(response.body)
          data = json["data"]["tasks"]["pageInfo"]

          expect(data["startCursor"]).to be_present
          expect(data["endCursor"]).to be_present
          expect(data["hasNextPage"]).to be true
          expect(data["hasPreviousPage"]).to be false
        end

        # This test definetely needs to be refactored
        it "returns the first page of tasks" do
          post "/api/graphql", params: { query: first_query }, headers: auth_headers(token)
          json = JSON.parse(response.body)
          data = json["data"]["tasks"]["edges"]

          response_ids = data.map { |task| task["node"]["id"] }
          tasks_ids = tasks.map(&:id).map(&:to_s).sort

          expect(response_ids.size).to eq(2)
          expect(tasks_ids & response_ids).to match_array(response_ids) # https://stackoverflow.com/a/7387998
        end

        # This test definetely needs to be refactored
        it "returns the second page of tasks" do
          post "/api/graphql", params: { query: first_query }, headers: auth_headers(token)
          first_response = JSON.parse(response.body)
          first_data = first_response["data"]["tasks"]["edges"]
          cursor = first_response["data"]["tasks"]["pageInfo"]["endCursor"]

          second_query = <<~GQL
            query {
              tasks(projectId: #{project.id}, first: 2, after: "#{cursor}", query: {s: "id asc"}) {
                edges{
                  node {
                    id
                  }
                }
              }
            }
          GQL

          post "/api/graphql", params: { query: second_query }, headers: auth_headers(token)
          second_response = JSON.parse(response.body)
          second_data = second_response["data"]["tasks"]["edges"]

          nodes_ids = first_data.map { |task| task["node"]["id"] } + second_data.map { |task| task["node"]["id"] }
          tasks_ids = tasks.map(&:id).map(&:to_s)

          expect(second_data.size).to eq(2)
          expect(nodes_ids).to match_array(tasks_ids)
        end
      end
    end
  end
end
