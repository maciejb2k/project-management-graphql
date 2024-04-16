# frozen_string_literal: true

module Mutations
  RSpec.describe CreateProjectMutation, type: :request do
    describe "#resolve" do
      let!(:user) { create(:user) }
      let!(:tokens) { sign_in(user) }

      context "when the request is valid" do
        let!(:valid_query) { create_query(title: "Project 1") }

        it "creates a project" do
          expect do
            post "/api/graphql", params: { query: valid_query }, headers: auth_headers(tokens)
          end.to change(Project, :count).by(1)
        end

        it "returns a project" do
          post "/api/graphql", params: { query: valid_query }, headers: auth_headers(tokens)
          json = JSON.parse(response.body)
          project = json["data"]["createProject"]["project"]

          expect(project).to include(
            "title" => "Project 1"
          )
        end

        it "sets the current user as the owner of the project" do
          post "/api/graphql", params: { query: valid_query }, headers: auth_headers(tokens)
          json = JSON.parse(response.body)
          project = json["data"]["createProject"]["project"]

          expect(project["members"].count).to eq(1)
          expect(project["members"].first["email"]).to eq(user.email)
          expect(project["owner"]["email"]).to eq(user.email)
          expect(ProjectMember.where(user:, project: project["id"], role: "owner").count).to eq(1)
        end
      end

      context "when the request is invalid" do
        let!(:invalid_query) { create_query(title: "") }

        it "returns an validation error" do
          post "/api/graphql", params: { query: invalid_query }, headers: auth_headers(tokens)
          json = JSON.parse(response.body)
          errors = json["data"]["createProject"]["errors"]

          expect(errors).to be_present
          expect(errors).to include("Title can't be blank")
        end
      end
    end

    def create_query(title: "Project 1")
      <<~GQL
        mutation {
          createProject(input: { attributes: { title: "#{title}" }}) {
            project {
              id
              title
              members {
                email
              }
              owner {
                email
              }
            }
            errors
          }
        }
      GQL
    end
  end
end
