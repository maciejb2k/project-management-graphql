# frozen_string_literal: true

class TodoGraphqlSchema < GraphQL::Schema
  mutation Types::MutationType
  query Types::QueryType

  use GraphQL::Dataloader

  def self.resolve_type(abstract_type, obj, ctx)
    raise(GraphQL::RequiredImplementationMissingError)
  end

  validate_max_errors 100
  default_page_size 25
  default_max_page_size 100

  # Relay-style Object Identification:

  def self.id_from_object(object, type_definition, query_ctx)
    object.to_gid_param
  end

  def self.object_from_id(global_id, query_ctx)
    GlobalID.find(global_id)
  end
end
