# frozen_string_literal: true

Rails.logger = Logger.new($stdout)
Rails.logger.info "Seeding database"

Doorkeeper::Application.create(name: "WebApp", redirect_uri: "", scopes: "")

Rails.logger.info "Doorkeeper application created"

Role.create(
  [
    { name: "supervisor" },
    { name: "manager" },
    { name: "operator" },
    { name: "default" }
  ]
)

Rails.logger.info "Roles created"

Permission.create(
  [
    { action: "create",        resource: "task" },
    { action: "read",          resource: "task" },
    { action: "update",        resource: "task" },
    { action: "delete",        resource: "task" },
    { action: "status_change", resource: "task" }
  ]
)

Rails.logger.info "Permissions created"

Role.find_by(name: "supervisor").permissions << Permission.where(
  action: %w[create read update delete status_change],
  resource: "task"
)

Role.find_by(name: "manager").permissions << Permission.where(
  action: %w[create read update delete],
  resource: "task"
)

Role.find_by(name: "operator").permissions << Permission.where(
  action: %w[read status_change],
  resource: "task"
)

Rails.logger.info "Permissions associated with roles"

users = User.create!(
  [
    { email: "maciek@example.com", password: "password" },
    { email: "konrad@example.com", password: "password" },
    { email: "anna@example.com", password: "password" }
  ]
)

Rails.logger.info "Users created"

User.find_by(email: "maciek@example.com").roles << Role.find_by(name: "supervisor")
User.find_by(email: "konrad@example.com").roles << Role.find_by(name: "manager")
User.find_by(email: "anna@example.com").roles << Role.find_by(name: "operator")

Rails.logger.info "Users roles associated"

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
