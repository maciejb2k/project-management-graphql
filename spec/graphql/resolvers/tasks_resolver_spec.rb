# frozen_string_literal: true

module Resolvers
  RSpec.describe TasksResolver, type: :request do
    # Unit test for the resolver
    describe "#resolve" do
      subject(:resolve) { described_class.new(object: nil, field: nil, context: nil).resolve }

      let!(:tasks) { create_list(:task, 3) }

      it "returns all tasks" do
        expect(resolve).to match_array(tasks)
      end
    end

    # Integration test for the resolver
    describe "API requests" do
      describe "request without parameters" do
        let!(:tasks) { create_list(:task, 3) }
        let!(:valid_query) do
          <<~GQL
            query {
              tasks {
                nodes {
                  id
                }
              }
            }
          GQL
        end

        it "returns all tasks" do
          json = fetch_tasks(valid_query)
          data = json["data"]["tasks"]["nodes"]

          expect(data).to match_array(tasks.map { |task| { "id" => task.id.to_s, } })
        end
      end

      describe "request with filtering" do
        before { create_list(:task, 3) }

        let!(:task) { create(:task, title: "task to find") }
        let!(:valid_query) do
          <<~GQL
            query {
              tasks(query: { title_eq: "task to find" }) {
                nodes {
                  id
                }
              }
            }
          GQL
        end

        it "returns the filtered tasks" do
          json = fetch_tasks(valid_query)
          data = json["data"]["tasks"]["nodes"]

          expect(data).to match_array([{ "id" => task.id.to_s }])
        end
      end

      describe "request with sorting" do
        before { %w[a b c].map { |title| create(:task, title:) } }

        let(:valid_query) do
          <<~GQL
            query {
              tasks(query: { s: "title desc" }) {
                nodes {
                  id
                  title
                }
              }
            }
          GQL
        end

        it "returns the sorted tasks" do
          json = fetch_tasks(valid_query)
          data = json["data"]["tasks"]["nodes"]
          titles = data.map { |task| task["title"] }

          expect(titles).to eq(%w[c b a])
        end
      end

      describe "request with connection pagination" do
        let!(:tasks) { create_list(:task, 4) }
        let!(:first_query) do
          <<~GQL
            query {
              tasks(first: 2) {
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
          json = fetch_tasks(first_query)
          data = json["data"]["tasks"]["pageInfo"]

          expect(data["startCursor"]).to be_present
          expect(data["endCursor"]).to be_present
          expect(data["hasNextPage"]).to be true
          expect(data["hasPreviousPage"]).to be false
        end

        # This test definetely needs to be refactored
        it "returns the first page of tasks" do
          json = fetch_tasks(first_query)
          data = json["data"]["tasks"]["edges"]
          nodes_ids = data.map { |task| task["node"]["id"] }.sort
          tasks_ids = tasks.map(&:id).map(&:to_s).sort

          expect(nodes_ids.size).to eq(2)
          expect(tasks_ids & nodes_ids).to eq(nodes_ids) # https://stackoverflow.com/a/7387998
        end

        # This test definetely needs to be refactored
        it "returns the second page of tasks" do
          first_response = fetch_tasks(first_query)
          first_data = first_response["data"]["tasks"]["edges"]
          cursor = first_response["data"]["tasks"]["pageInfo"]["endCursor"]

          second_query = <<~GQL
            query {
              tasks(first: 2, after: "#{cursor}", query: {s: "id asc"}) {
                edges{
                  node {
                    id
                  }
                }
              }
            }
          GQL

          second_response = fetch_tasks(second_query)
          second_data = second_response["data"]["tasks"]["edges"]

          nodes_ids = first_data.map { |task| task["node"]["id"] } + second_data.map { |task| task["node"]["id"] }
          tasks_ids = tasks.map(&:id).map(&:to_s)

          expect(second_data.size).to eq(2)
          expect(nodes_ids).to match_array(tasks_ids)
        end
      end
    end

    def fetch_tasks(query)
      post "/api/graphql", params: { query: }
      JSON.parse(response.body)
    end
  end
end
