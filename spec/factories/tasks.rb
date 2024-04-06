FactoryBot.define do
  factory :task do
    sequence(:title) { |n| "Task #{n}" }
    status { Task::STATUS_OPTIONS.sample }
  end
end
