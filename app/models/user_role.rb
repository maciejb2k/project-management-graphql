# frozen_string_literal: true

# == Schema Information
#
# Table name: user_roles
#
#  id         :bigint           not null, primary key
#  role_id    :bigint           not null
#  user_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class UserRole < ApplicationRecord
  belongs_to :user
  belongs_to :role

  validates :role_id, uniqueness: { scope: :user_id }

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at id role_id updated_at user_id]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[role user]
  end
end
