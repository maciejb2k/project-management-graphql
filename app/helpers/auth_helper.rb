# frozen_string_literal: true

module AuthHelper
  include Pundit::Authorization

  def authenticate_user!
    raise GraphQL::ExecutionError, "You need to sign in or sign up before continuing." unless current_user
  end

  def current_user
    context[:current_user]
  end
end
