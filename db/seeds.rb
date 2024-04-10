# frozen_string_literal: true

users = User.create(
  [
    { email: "maciek@example.com", username: "maciek", password: "password" },
    { email: "konrad@example.com", username: "konrad", password: "password" },
    { email: "anna@example.com", username: "anna", password: "password" }
  ]
)

projects = users.map do |user|
  Project.create(
    user:,
    title: "Research for #{Faker::Beer.style}",
    description: Faker::Lorem.paragraph
  )
end

projects.each do |project|
  8.times do
    Task.create(
      project:,
      title: "Try out #{Faker::Beer.name}",
      status: Task::STATUS_OPTIONS.sample
    )
  end
end
