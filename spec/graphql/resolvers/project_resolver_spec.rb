# frozen_string_literal: true

module Resolvers
  RSpec.describe ProjectResolver, type: :request do
    context "when user is not authenticated" do
      let(:query) { create_query(id: 1) }

      include_examples "returns an error when user is not authenticated"
    end

    context "when user is authenticated" do
      let!(:user) { create(:user) }
      let!(:tokens) { sign_in(user) }

      context "when user requests a project that doesn't belong to them" do
        let!(:project) { create(:project, user: create(:user)) }
        let!(:query) { create_query(id: project.id) }

        it "returns an error" do
          expect do
            post "/api/graphql", params: { query: }, headers: auth_headers(tokens)
          end.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context "when user requests a project that belongs to them" do
        let!(:project) { create(:project, user:) }
        let!(:query) { create_query(id: project.id) }

        it "returns the project" do
          post "/api/graphql", params: { query: }, headers: auth_headers(tokens)
          json = JSON.parse(response.body)
          data = json["data"]["project"]

          expect(data).to eq("id" => project.id.to_s)
        end
      end

      context "when request has invalid id" do
        let!(:project) { create(:project, user:) }
        let!(:invalid_query) { create_query(id: project.id) }

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

    def create_query(id:)
      <<~GQL
        query {
          project(id: #{id}) {
            id
          }
        }
      GQL
    end
  end
end
