# frozen_string_literal: true

# == Schema Information
#
# Table name: projects
#
#  id          :bigint           not null, primary key
#  title       :string           default(""), not null
#  description :string
#  start_date  :date
#  end_date    :date
#  is_deleted  :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint           not null
#
FactoryBot.define do
  factory :project do
    title { Faker::App.name }
    description { Faker::Lorem.sentence }
    start_date { Faker::Date.between(from: 2.days.ago, to: Time.zone.today) }
    end_date { Faker::Date.between(from: Time.zone.today, to: 1.year.from_now) }
    user

    after(:create) do |project|
      create(:project_member, project:, user: project.user, role: "owner")
    end
  end
end
