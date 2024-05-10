# Rails GraphQL Project Management

Simple project management system with GraphQL API, allowing multiple users collaborating on projects and tasks.

![graphiql](https://github.com/maciejb2k/todo-graphql/assets/6316812/778f5833-98e4-47af-9f51-cb48e375da47)

## Technologies

`Ruby 3.2.0`, `Rails 7.0`, `PostgreSQL`, `GraphQL`, `GraphiQL`, `Ransack`, `RSpec`, `FactoryBot`, `Faker`, `Rubocop`, `Pry`, `Devise`, `Doorkeeper`, `Pundit`, `ActiveAdmin`.

## Implemented Functionalities

- **GraphQL API** with pagination, sorting, filtering, and error handling
- User authentication with **Devise** and **OAuth 2.0** API access with **Doorkeeper**
- **RBAC** (Role-based access control) with fully customizable **permissions matrix**
- Authorization with **Pundit** policies
- Admin panel with **ActiveAdmin** for system admin
- **RSpec** with fully coverd graphql queries and mutations

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
