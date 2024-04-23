# frozen_string_literal: true

# == Schema Information
#
# Table name: tasks
#
#  id             :bigint           not null, primary key
#  title          :string           not null
#  estimated_time :integer
#  delivered_time :integer
#  status         :string           default("todo"), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  project_id     :bigint           not null
#
FactoryBot.define do
  factory :task do
    sequence(:title) { |n| "Task #{n}" }
    status { Task::STATUS_OPTIONS.sample }
    project
  end
end
