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
#
class ProjectMember < ApplicationRecord
  belongs_to :project
  belongs_to :user

  validates :project_id, uniqueness: { scope: :user_id }
end
