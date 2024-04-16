# frozen_string_literal: true

# Terms explanations:
# user - a target user (project mamber) who will be added to the project
# authenticated user - a user who is authenticated and owns the project (owner)
# project - a project which belongs to the authenticated user (owner)

module Mutations
  RSpec.describe AddProjectMemberMutation, type: :request do
    describe "#resolve" do
      shared_context "when the user is authenticated" do
        let(:user) { create(:user) }
        let(:tokens) { sign_in(user) }
      end

      shared_context "when the project exists" do
        include_context "when the user is authenticated"

        let(:project) { create(:project, user:) }
      end

      context "when then project does not exist" do
        include_context "when the user is authenticated"

        let!(:query) { create_query(project_id: 0, user_id: user.id, role: "developer") }

        it "returns an error" do
          expect do
            post "/api/graphql", params: { query: }, headers: auth_headers(tokens)
          end.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context "when the authenticated user is not the project owner" do
        include_context "when the project exists"

        let!(:project_member) { create(:user) }
        let!(:query) { create_query(project_id: project.id, user_id: project_member.id, role: "developer") }

        before do
          project.update(user: create(:user))
        end

        it "returns an error" do
          post "/api/graphql", params: { query: }, headers: auth_headers(tokens)
          json = JSON.parse(response.body)
          data = json["errors"][0]["message"]

          expect(data).to eq("You are not authorized to perform this action.")
        end
      end

      context "when the authenticated user is the project owner" do
        context "when the user exists" do
          context "when the user is not a member of the project" do
            include_context "when the project exists"

            let!(:project_member) { create(:user) }
            let!(:query) { create_query(project_id: project.id, user_id: project_member.id, role: "developer") }

            it "adds the user to the project as a member" do
              post "/api/graphql", params: { query: }, headers: auth_headers(tokens)
              json = JSON.parse(response.body)
              data = json["data"]["addProjectMember"]

              expect(data["projectMember"]["user"]["id"]).to eq(project_member.id.to_s)
              expect(data["projectMember"]["user"]["email"]).to eq(project_member.email)
              expect(data["errors"]).to be_empty
            end
          end

          context "when the user is a member of the project" do
            include_context "when the project exists"

            let!(:project_member) { create(:user) }
            let!(:query) { create_query(project_id: project.id, user_id: project_member.id, role: "developer") }

            before do
              project.project_members.create(user: project_member, role: "developer")
            end

            it "does not add the user to the project twice" do
              post "/api/graphql", params: { query: }, headers: auth_headers(tokens)
              json = JSON.parse(response.body)
              data = json["data"]["addProjectMember"]

              expect(data["errors"]).to eq(["Project has already been taken"])
            end
          end

          context "when the user role is invalid" do
            include_context "when the project exists"

            let!(:project_member) { create(:user) }
            let!(:query) { create_query(project_id: project.id, user_id: project_member.id, role: "invalid") }

            it "returns an error" do
              post "/api/graphql", params: { query: }, headers: auth_headers(tokens)
              json = JSON.parse(response.body)
              data = json["errors"][0]["message"]

              expect(data).to include(
                "Argument 'role' on InputObject 'AddProjectMemberMutationInput' has an invalid value"
              )
            end
          end
        end

        context "when the user does not exist" do
          include_context "when the project exists"

          let!(:query) { create_query(project_id: project.id, user_id: 0, role: "developer") }

          it "returns an error" do
            expect do
              post "/api/graphql", params: { query: }, headers: auth_headers(tokens)
            end.to raise_error(ActiveRecord::RecordNotFound)
          end
        end
      end
    end

    def create_query(project_id:, user_id:, role:)
      <<~GQL
        mutation {
          addProjectMember(input: { projectId: #{project_id}, userId: #{user_id}, role: #{role} }) {
            errors
            projectMember {
              user {
                id
                email
              }
            }
          }
        }
      GQL
    end
  end
end
