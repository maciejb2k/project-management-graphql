# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    title { Faker::App.name }
    description { Faker::Lorem.sentence }
    start_date { Faker::Date.between(from: 2.days.ago, to: Time.zone.today) }
    end_date { Faker::Date.between(from: Time.zone.today, to: 1.year.from_now) }
    user
  end
end
