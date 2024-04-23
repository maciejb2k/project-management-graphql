# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { "password" }

    transient do
      role_name { "supervisor" }
    end

    trait :supervisor do
      role_name { "supervisor" }
    end

    trait :manager do
      role_name { "manager" }
    end

    trait :operator do
      role_name { "operator" }
    end

    after(:create) do |user, evaluator|
      role = Role.find_by!(name: evaluator.role_name)
      user.user_roles.create(role:)
    end
  end
end
