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

gem "dotenv-rails", "~> 3.1.0"

gem "bcrypt", "~> 3.1.7"
gem "devise", "~> 4.9.4"
gem "doorkeeper", "~> 5.6.9"

gem "graphql", "~> 2.3.0"
gem "graphiql-rails", "~> 1.10.0"
gem "ar_lazy_preload", "~> 2.1.0"

gem "ransack", "~> 4.1.1"

gem "pundit", "~> 2.3.1"

gem "annotate", "~> 3.2.0"
gem "validates_timeliness", "~> 7.0.0.beta1"

gem "sassc-rails", "~> 2.1.2"

gem "activeadmin", "~> 3.2.0"
gem "activeadmin-searchable_select", "~> 1.8.0"
gem "active_admin_datetimepicker", "~> 1.1.0"

gem "faker", "~> 3.3.0"
gem "pry", "~> 0.14.2"

group :development, :test do
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "rspec-rails", "~> 6.1.2"
  gem "rspec-graphql_matchers", "~> 2.0.0.pre.rc.0"
  gem "factory_bot_rails", "~> 6.4.3"
  gem "shoulda-matchers", "~> 6.2.0"
  gem "test-prof", "~> 1.3.2"
  gem "activerecord-explain-analyze", "~> 0.1.0"

  gem "rubocop", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
end

group :development do
  gem "web-console"
end
