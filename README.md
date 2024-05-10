# Rails GraphQL Project Management

Simple project management system with GraphQL API, allowing multiple users collaborating on projects and tasks.

![graphiql](https://github.com/maciejb2k/chronlife/assets/6316812/b743a36f-06d3-4d0c-87cb-96b88dd3c516)

## Technologies

`Ruby 3.2.0`, `Rails 7.0`, `PostgreSQL`, `GraphQL`, `GraphiQL`, `Ransack`, `RSpec`, `FactoryBot`, `Faker`, `Rubocop`, `Pry`, `Devise`, `Doorkeeper`, `Pundit`, `ActiveAdmin`.

## Implemented Functionalities

- [x] **GraphQL API** with pagination, sorting, filtering, and error handling.
- [x] User authentication with **Devise** and **OAuth 2.0** API access with **Doorkeeper**.
- [x] Authorization rules with **Pundit** policies.
- [x] **RBAC** (Role-based access control) with fully customizable **permissions matrix**.
- [x] Admin panel with **ActiveAdmin** for system admin.
- [x] **RSpec** specs with fully covered graphql queries and mutations.

Below is a ERD diagram of the project:

![ERD](https://github.com/maciejb2k/chronlife/assets/6316812/0cf9ad81-bbcc-46d4-bf1c-78a985b9d67d)

## Getting Started

Go to `docker-compose.yml`, comment line `17` and uncomment line `18`, then run this command to setup the database:
```bash
docker compose up
```

Then exit containers (try spamming `CTRL+C`), comment back line `18` and uncomment line `17`, then run the following command and you are ready to go:
```bash
docker compose up -d && docker compose attach app
```

To run specs, attach to the `app` (attach shell in the VSCode or from CLI run `docker compose exec -it app bash`) container and run (test database must be seeded):
```bash
RAILS_ENV=test rails db:reset && rspec
```
