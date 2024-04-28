# frozen_string_literal: true

class ApplicationPolicy
  class Scope
    include PermissionCheck

    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end
  end

  include PermissionCheck

  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end
end
