# frozen_string_literal: true

# == Schema Information
#
# Table name: permissions
#
#  id         :bigint           not null, primary key
#  action     :string           not null
#  resource   :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Permission < ApplicationRecord
  has_many :role_permissions, dependent: :destroy
  has_many :roles, through: :role_permissions

  validates :action, presence: true, uniqueness: { scope: :resource }
  validates :resource, presence: true

  def self.ransackable_associations(_auth_object = nil)
    %w[role_permissions roles]
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[action created_at id resource updated_at]
  end

  def display_name
    ":#{action}, :#{resource}"
  end
end
