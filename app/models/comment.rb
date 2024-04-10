# frozen_string_literal: true

# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  content    :text             default(""), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  task_id    :bigint           not null
#  user_id    :bigint           not null
#
class Comment < ApplicationRecord
  belongs_to :task
  belongs_to :user

  validates :content, presence: true, length: { maximum: 500 }
end
