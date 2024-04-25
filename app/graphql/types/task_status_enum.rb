# frozen_string_literal: true

module Types
  class TaskStatusEnum < Types::BaseEnum
    Task::STATUS_OPTIONS.each do |status|
      value status.to_s, status.to_s
    end
  end
end
