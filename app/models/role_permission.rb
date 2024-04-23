# frozen_string_literal: true

# == Schema Information
#
# Table name: role_permissions
#
#  id            :bigint           not null, primary key
#  role_id       :bigint           not null
#  permission_id :bigint           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class RolePermission < ApplicationRecord
  belongs_to :role
  belongs_to :permission

  validates :role_id, uniqueness: { scope: :permission_id }

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at id permission_id role_id updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[permission role]
  end
end
