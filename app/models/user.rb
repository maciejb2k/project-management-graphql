# frozen_string_literal: true

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
class User < ApplicationRecord
  has_secure_password
  has_secure_password :recovery_password, validations: false

  has_many :projects, dependent: :destroy
  has_many :project_members, dependent: :destroy
  has_many :memberships, through: :project_members, source: :project
  has_many :comments, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true
  validates :first_name, length: { minimum: 3, maximum: 50 }, allow_blank: true
  validates :last_name, length: { minimum: 3, maximum: 50 }, allow_blank: true
end
