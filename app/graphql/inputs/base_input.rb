# frozen_string_literal: true

module Inputs
  class BaseInput < GraphQL::Schema::InputObject
    def prepare
      to_h
    end
  end
end
