# frozen_string_literal: true

users = User.create(
  [
    { email: "maciek@example.com", password: "password" },
    { email: "konrad@example.com", password: "password" },
    { email: "anna@example.com", password: "password" }
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
