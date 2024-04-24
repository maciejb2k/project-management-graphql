# frozen_string_literal: true

# == Schema Information
#
# Table name: roles
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Role < ApplicationRecord
  has_many :user_roles, dependent: :destroy
  has_many :users, through: :user_roles

  has_many :role_permissions, dependent: :destroy
  has_many :permissions, through: :role_permissions

  validates :name, presence: true, uniqueness: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at id name updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[permissions role_permissions user_roles users]
  end
end
