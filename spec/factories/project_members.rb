# frozen_string_literal: true

FactoryBot.define do
  factory :project_member do
    project
    user
    role { "developer" }
  end
end
