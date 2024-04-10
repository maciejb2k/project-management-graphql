# frozen_string_literal: true

module Mutations
  RSpec.describe UpdateProjectMutation, type: :request do
    describe "#resolve" do
      let!(:user) { create(:user) }
      let!(:project) { create(:project, user:, title: "Project 1") }
      let!(:tokens) { sign_in(user) }

      context "when the request is valid" do
        let!(:valid_query) { update_query(id: project.id, title: "New project title") }

        it "updates a project" do
          post "/api/graphql", params: { query: valid_query }, headers: auth_headers(tokens)
          project.reload

          expect(project.title).to eq("New project title")
        end

        it "returns a project" do
          post "/api/graphql", params: { query: valid_query }, headers: auth_headers(tokens)
          json = JSON.parse(response.body)
          project = json["data"]["updateProject"]["project"]

          expect(project).to include(
            "title" => "New project title"
          )
        end
      end

      context "when the request is invalid" do
        let!(:invalid_query) { update_query(id: project.id, title: "") }

        it "returns an validation error" do
          post "/api/graphql", params: { query: invalid_query }, headers: auth_headers(tokens)
          json = JSON.parse(response.body)
          errors = json["data"]["updateProject"]["errors"]

          expect(errors).to be_present
          expect(errors).to include("Title can't be blank")
        end
      end
    end

    def update_query(id:, title: "Project 1")
      <<~GQL
        mutation {
          updateProject(input: { id: #{id}, attributes: { title: "#{title}" }}) {
            project {
              id
              title
            }
            errors
          }
        }
      GQL
    end
  end
end
