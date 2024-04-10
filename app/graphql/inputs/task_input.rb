# frozen_string_literal: true

module Inputs
  class TaskInput < Inputs::BaseInput
    description "Attributes for creating or updating an Task"

    argument :title, String, required: true
    argument :status, String, required: true
    argument :estimated_time, Integer, required: false
    argument :delivered_time, Integer, required: false
  end
end
