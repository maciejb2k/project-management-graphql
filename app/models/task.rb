# frozen_string_literal: true

# == Schema Information
#
# Table name: tasks
#
#  id             :bigint           not null, primary key
#  title          :string           not null
#  estimated_time :integer
#  delivered_time :integer
#  status         :string           default("todo"), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  project_id     :bigint           not null
#
class Task < ApplicationRecord
  belongs_to :project
  has_many :comments, dependent: :destroy

  STATUS_OPTIONS = %w[todo doing done].freeze

  validates :title, presence: true
  validates :estimated_time, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validates :delivered_time, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validates :status, presence: true, inclusion: { in: STATUS_OPTIONS }

  def self.ransackable_attributes(_auth_object = nil)
    %w[title estimated_time delivered_time status]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[comments project]
  end

  def change_status!(status)
    update(status:)
  end
end
