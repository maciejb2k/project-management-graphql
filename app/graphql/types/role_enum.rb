# frozen_string_literal: true

module Types
  class RoleEnum < Types::BaseEnum
    ProjectMember::ROLES.each do |role|
      value role.to_s.titleize, role.to_s, description: "A #{role} of a project"
    end
  end
end
