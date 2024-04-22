# frozen_string_literal: true

Rails.logger = Logger.new($stdout)
Rails.logger.info "Seeding database"

Doorkeeper::Application.create(name: "WebApp", redirect_uri: "", scopes: "") if Doorkeeper::Application.count.zero?

Rails.logger.info "Doorkeeper application created"

users = User.create(
  [
    { email: "maciek@example.com", password: "password" },
    { email: "konrad@example.com", password: "password" },
    { email: "anna@example.com", password: "password" }
  ]
)

Rails.logger.info "Users created"

projects = users.map do |user|
  project = Project.create(
    user:,
    title: "Research for #{Faker::Beer.style}",
    description: Faker::Lorem.paragraph
  )
  project.project_members.create(user:, role: "owner")

  project
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

Rails.logger.info "Projects and tasks created"

Rails.logger.info "Seeding finished"
