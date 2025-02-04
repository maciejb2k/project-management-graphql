# frozen_string_literal: true

module Api
  class GraphqlController < ApplicationController
    def execute
      variables = prepare_variables(params[:variables])
      query = params[:query]
      operation_name = params[:operationName]
      context = {
        # `doorkeeper_token` can be used to retrieve scopes, but when
        # passing devise `current_user`, we can't use oauth scopes anymore.
        current_user: current_user || current_resource_owner,
        doorkeeper_token:
      }
      result = TodoGraphqlSchema.execute(query, variables:, context:, operation_name:)

      render json: result
    rescue StandardError => e
      raise e unless Rails.env.development?

      handle_error_in_development(e)
    end

    private

    # Handle variables in form data, JSON body, or a blank value
    def prepare_variables(variables_param)
      case variables_param
      when String
        if variables_param.present?
          JSON.parse(variables_param) || {}
        else
          {}
        end
      when Hash
        variables_param
      when ActionController::Parameters
        variables_param.to_unsafe_hash # GraphQL-Ruby will validate name and type of incoming variables.
      when nil
        {}
      else
        raise ArgumentError, "Unexpected parameter: #{variables_param}"
      end
    end

    def handle_error_in_development(err)
      logger.error err.message
      logger.error err.backtrace.join("\n")

      render json: { errors: [{ message: err.message, backtrace: err.backtrace }], data: {} },
             status: :internal_server_error
    end
  end
end
