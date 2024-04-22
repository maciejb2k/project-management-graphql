# frozen_string_literal: true

RSpec.shared_examples "returns an error when user is not authenticated" do
  it "returns an error" do
    post "/api/graphql", params: { query: }
    json = JSON.parse(response.body)
    errors = json["errors"]

    expect(errors.size).to eq(1)
    expect(errors.first["message"]).to eq("You need to sign in or sign up before continuing.")
  end
end
