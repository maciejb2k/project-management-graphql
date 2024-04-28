# frozen_string_literal: true

module PermissionCheck
  extend ActiveSupport::Concern

  def permission?(action, resource)
    user.permission?(action:, resource:)
  end
end
