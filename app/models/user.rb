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
class User < ApplicationRecord
  after_create :assign_default_role

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :access_grants,
           class_name: "Doorkeeper::AccessGrant",
           foreign_key: :resource_owner_id,
           dependent: :delete_all, # or :destroy if you need callbacks
           inverse_of: :resource_owner

  has_many :access_tokens,
           class_name: "Doorkeeper::AccessToken",
           foreign_key: :resource_owner_id,
           dependent: :delete_all, # or :destroy if you need callbacks
           inverse_of: :resource_owner

  has_many :user_roles, dependent: :destroy
  has_many :roles, through: :user_roles

  has_many :projects, dependent: :destroy
  has_many :project_members, dependent: :destroy
  has_many :memberships, through: :project_members, source: :project
  has_many :comments, dependent: :destroy

  def self.ransackable_attributes(_auth_object = nil)
    %w[email created_at updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[memberships project_members projects roles user_roles]
  end

  def display_name
    email
  end

  def self.authenticate(email, password)
    user = User.find_for_authentication(email:)
    user&.valid_password?(password) ? user : nil
  end

  def role?(name)
    roles.exists?(name:)
  end

  def permission?(action:, resource:)
    roles.joins(:permissions).where(permissions: { action:, resource: }).exists?
  end

  private

  def assign_default_role
    default_role = Role.find_by(name: "default")
    user_roles.create(role: default_role)
  end
end
