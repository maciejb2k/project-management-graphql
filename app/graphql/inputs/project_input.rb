# frozen_string_literal: true

module Inputs
  class ProjectInput < Inputs::BaseInput
    description "Attributes for creating or updating an Project"

    argument :title, String, required: true
    argument :description, String, required: false
    argument :start_date, GraphQL::Types::ISO8601Date, required: false
    argument :end_date, GraphQL::Types::ISO8601Date, required: false
  end
end
