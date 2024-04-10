# frozen_string_literal: true

module AuthHelper
  include JWTSessions::Authorization

  def current_user
    @current_user ||= User.find(payload["user_id"])
  end

  def request_headers
    context[:request_headers]
  end

  def request_cookies
    context[:request_cookies]
  end

  def request_method
    context[:request_method]
  end
end
