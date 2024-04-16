# frozen_string_literal: true

# == Schema Information
#
# Table name: projects
#
#  id          :bigint           not null, primary key
#  title       :string           default(""), not null
#  description :string
#  start_date  :date
#  end_date    :date
#  is_deleted  :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint           not null
#
class Project < ApplicationRecord
  belongs_to :user

  has_many :tasks, dependent: :destroy
  has_many :project_members, dependent: :destroy
  has_many :members, through: :project_members, source: :user

  validates :title, presence: true
  validates :description, length: { maximum: 500 }, allow_blank: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[title description]
  end

  def add_member(user)
    members << user
  end

  def remove_member(user)
    members.delete(user)
  end

  def owner
    user
  end

  def member?(user)
    members.include?(user)
  end
end
