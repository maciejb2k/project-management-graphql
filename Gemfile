# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.0"

gem "rails", "~> 7.0.8", ">= 7.0.8.1"
gem "sprockets-rails"
gem "pg", "~> 1.1"
gem "puma", "~> 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
gem "bootsnap", require: false

gem "bcrypt", "~> 3.1.7"
gem "jwt_sessions", "~> 3.2.2"
gem "dotenv-rails", "~> 3.1.0"
gem "graphql", "~> 2.3.0"
gem "graphiql-rails", "~> 1.10.0"
gem "ransack", "~> 4.1.1"
gem "pundit", "~> 2.3.1"
gem "annotate", "~> 3.2.0"
gem "validates_timeliness", "~> 7.0.0.beta1"
gem "faker", "~> 3.3.0"

group :development, :test do
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "rspec-rails", "~> 6.1.2"
  gem "rspec-graphql_matchers", "~> 2.0.0.pre.rc.0"
  gem "factory_bot_rails", "~> 6.4.3"
  gem "shoulda-matchers", "~> 6.2.0"
  gem "test-prof", "~> 1.3.2"

  gem "rubocop", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
end

group :development do
  gem "web-console"
end
