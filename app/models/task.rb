class Task < ApplicationRecord
  STATUS_OPTIONS = %w[todo doing done]

  validates :title, presence: true
  validates :estimated_time, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validates :delivered_time, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validates :status, presence: true, inclusion: { in: STATUS_OPTIONS }

  def self.ransackable_attributes(_auth_object = nil)
    %w[title estimated_time delivered_time status]
  end
end
