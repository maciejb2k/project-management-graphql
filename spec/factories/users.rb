# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email           :string           default(""), not null
#  username        :string           default(""), not null
#  first_name      :string           default(""), not null
#  last_name       :string           default(""), not null
#  password_digest :string           default(""), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    username { Faker::Internet.username }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    password { "password" }
  end
end
