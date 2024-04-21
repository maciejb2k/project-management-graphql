# frozen_string_literal: true

module Api
  class ApplicationController < ActionController::API
    def current_resource_owner
      User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
    end
  end
end
