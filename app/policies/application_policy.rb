# frozen_string_literal: true

class ApplicationPolicy
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def permission?(action, resource)
      user.permission?(action:, resource:)
    end
  end

  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def permission?(action, resource)
    user.permission?(action:, resource:)
  end
end
