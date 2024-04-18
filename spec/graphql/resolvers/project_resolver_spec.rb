# frozen_string_literal: true

module Resolvers
  RSpec.describe ProjectResolver, type: :request do
    describe "#resolve" do
      let!(:user) { create(:user) }
      let!(:tokens) { sign_in(user) }

      context "when user requests a project that doesn't belong to them" do
        let!(:project) { create(:project, user: create(:user)) }
        let!(:query) do
          <<~GQL
            query {
              project(id: #{project.id}) {
                id
              }
            }
          GQL
        end

        it "returns an error" do
          expect do
            post "/api/graphql", params: { query: }, headers: auth_headers(tokens)
          end.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context "when user requests a project that belongs to them" do
        let!(:project) { create(:project, user:) }
        let!(:query) do
          <<~GQL
            query {
              project(id: #{project.id}) {
                id
              }
            }
          GQL
        end

        it "returns the project" do
          post "/api/graphql", params: { query: }, headers: auth_headers(tokens)
          json = JSON.parse(response.body)
          data = json["data"]["project"]

          expect(data).to eq("id" => project.id.to_s)
        end
      end

      context "when request has invalid id" do
        let!(:project) { create(:project, user:) }
        let!(:invalid_query) do
          <<~GQL
            query {
              project(id: #{project.id}) {
                id
              }
            }
          GQL
        end

        before do
          project.destroy
        end

        it "returns an error" do
          expect do
            post "/api/graphql", params: { query: invalid_query }, headers: auth_headers(tokens)
          end.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end
end
