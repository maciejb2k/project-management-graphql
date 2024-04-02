# frozen_string_literal: true

module Resolvers
  class TaskResolver < Resolvers::BaseResolver
    description 'Get task by ID'

    type [Types::TaskType], null: false

    argument :id, ID, required: true, description: 'ID of the task'

    def resolve(id:)
      ::Task.find(id)
    end
  end
end
