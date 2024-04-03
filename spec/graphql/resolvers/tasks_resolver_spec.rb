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
          post "/graphql", params: { query: valid_query }

          json = JSON.parse(response.body)
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
          post "/graphql", params: { query: valid_query }

          json = JSON.parse(response.body)
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
          post "/graphql", params: { query: valid_query }

          json = JSON.parse(response.body)
          data = json["data"]["tasks"]["nodes"]
          titles = data.map { |task| task["title"] }

          expect(titles).to eq(%w[c b a])
        end
      end

      describe "request with connection pagination" do
        skip "returns the paginated tasks"
      end
    end
  end
end
