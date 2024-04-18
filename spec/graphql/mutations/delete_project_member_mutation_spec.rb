# frozen_string_literal: true

module Mutations
  RSpec.describe DeleteProjectMemberMutation, type: :request do
    describe "#resolve" do
      shared_context "when the user is authenticated" do
        let(:user) { create(:user) }
        let(:tokens) { sign_in(user) }
      end

      shared_context "when the project with members exists" do
        include_context "when the user is authenticated"

        let(:project) { create(:project, user:) }
        let(:members) { create_list(:user, 3) }

        before do
          members.each do |member|
            create(:project_member, project:, user: member)
          end
        end
      end

      context "when the project does not exist" do
        include_context "when the project with members exists"

        let!(:query) { create_query(project_id: 0, user_id: members.first.id) }

        it "returns an error" do
          expect do
            post "/api/graphql", params: { query: }, headers: auth_headers(tokens)
          end.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context "when the authenticated user is not the project owner" do
        include_context "when the project with members exists"

        let!(:query) { create_query(project_id: project.id, user_id: members.first.id) }

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
        context "when the deleting user is not a member of the project" do
          include_context "when the project with members exists"

          let!(:non_member) { create(:user) }
          let!(:query) { create_query(project_id: project.id, user_id: non_member.id) }

          it "returns an error" do
            expect do
              post "/api/graphql", params: { query: }, headers: auth_headers(tokens)
            end.to raise_error(ActiveRecord::RecordNotFound)
          end
        end

        context "when the deleting user is a member of the project" do
          include_context "when the project with members exists"

          let!(:query) { create_query(project_id: project.id, user_id: members.first.id) }

          it "removes the user from the project" do
            post "/api/graphql", params: { query: }, headers: auth_headers(tokens)
            json = JSON.parse(response.body)
            data = json["data"]["deleteProjectMember"]

            expect(data["success"]).to be_truthy
            expect(data["errors"]).to be_empty
            expect(project.members).not_to include(members.first)
          end
        end

        context "when the owner tries to delete himself from the project" do
          include_context "when the project with members exists"

          let!(:query) { create_query(project_id: project.id, user_id: user.id) }

          it "returns an error" do
            post "/api/graphql", params: { query: }, headers: auth_headers(tokens)
            json = JSON.parse(response.body)
            data = json["errors"][0]["message"]

            expect(data).to eq("You are not authorized to perform this action.")
          end
        end
      end

      context "when the project member tries to delete himself from the project" do
        include_context "when the project with members exists"

        let(:member_tokens) { sign_in(members.first) }
        let!(:query) { create_query(project_id: project.id, user_id: members.first.id) }

        it "removes the user from the project" do
          post "/api/graphql", params: { query: }, headers: auth_headers(member_tokens)
          json = JSON.parse(response.body)
          data = json["data"]["deleteProjectMember"]

          expect(data["success"]).to be_truthy
          expect(data["errors"]).to be_empty
          expect(project.members).not_to include(members.first)
        end
      end

      context "when non-project member tries to delete another user from the project" do
        include_context "when the project with members exists"

        let(:non_member) { create(:user) }
        let(:non_member_tokens) { sign_in(non_member) }
        let!(:query) { create_query(project_id: project.id, user_id: members.first.id) }

        it "returns an error" do
          post "/api/graphql", params: { query: }, headers: auth_headers(non_member_tokens)
          json = JSON.parse(response.body)
          data = json["errors"][0]["message"]

          expect(data).to eq("You are not authorized to perform this action.")
        end
      end
    end

    def create_query(project_id:, user_id:)
      <<~GQL
        mutation {
          deleteProjectMember(input: { projectId: #{project_id}, userId: #{user_id} }) {
            success
            errors
          }
        }
      GQL
    end
  end
end
