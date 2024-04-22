# frozen_string_literal: true

# == Schema Information
#
# Table name: project_members
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  project_id :bigint           not null
#  user_id    :bigint           not null
#  role       :string           default("guest"), not null
#
class ProjectMember < ApplicationRecord
  belongs_to :project
  belongs_to :user

  ROLES = %w[guest owner developer].freeze

  validates :role, presence: true, inclusion: { in: ROLES }
  validates :project_id, uniqueness: { scope: :user_id }
  validates :role, uniqueness: { scope: %i[project_id user_id], if: -> { owner? } }

  def owner?
    role == "owner"
  end
end
