# frozen_string_literal: true

Rails.logger = Logger.new($stdout)
Rails.logger.info "[SEED] Seeding database"

Doorkeeper::Application.create(name: "WebApp", redirect_uri: "", scopes: "")

Rails.logger.info "[SEED] Doorkeeper application created"

Role.create(
  [
    { name: "supervisor" },
    { name: "manager" },
    { name: "operator" },
    { name: "default" }
  ]
)

Rails.logger.info "[SEED] Roles created"

Permission.create(
  [
    { action: "create",        resource: "task" },
    { action: "read",          resource: "task" },
    { action: "update",        resource: "task" },
    { action: "delete",        resource: "task" },
    { action: "status_change", resource: "task" },

    { action: "create",        resource: "project" },
    { action: "read",          resource: "project" },
    { action: "update",        resource: "project" },
    { action: "delete",        resource: "project" }
  ]
)

Rails.logger.info "[SEED] Permissions created"

supervisor = Role.find_by(name: "supervisor")
supervisor.permissions << Permission.where(
  action: %w[create read update delete status_change],
  resource: "task"
)
supervisor.permissions << Permission.where(
  action: %w[create read update delete],
  resource: "project"
)

manager = Role.find_by(name: "manager")
manager.permissions << Permission.where(
  action: %w[create read update delete],
  resource: "task"
)

operator = Role.find_by(name: "operator")
operator.permissions << Permission.where(
  action: %w[read status_change],
  resource: "task"
)

Rails.logger.info "[SEED] Permissions associated with roles"

users = User.create!(
  [
    { email: "maciek@example.com", password: "password" },
    { email: "konrad@example.com", password: "password" },
    { email: "anna@example.com", password: "password" },
    { email: "tomek@example.com", password: "password" }
  ]
)

Rails.logger.info "[SEED] Users created"

if Rails.env.development? || Rails.env.test?
  AdminUser.create!(
    email: "admin@example.com",
    password: "password",
    password_confirmation: "password"
  )

  Rails.logger.info "[SEED] Admin user created"
end

User.find_by(email: "maciek@example.com").roles << Role.find_by(name: "supervisor")
User.find_by(email: "konrad@example.com").roles << Role.find_by(name: "manager")
User.find_by(email: "anna@example.com").roles << Role.find_by(name: "operator")

Rails.logger.info "[SEED] Users roles associated"

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

Rails.logger.info "[SEED] Projects and tasks created"
Rails.logger.info "[SEED] Seeding finished"
