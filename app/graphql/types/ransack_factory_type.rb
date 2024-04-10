# frozen_string_literal: true

module Types
  class RansackFactoryType
    def self.build(model)
      Class.new(Inputs::BaseInput) do
        model_name = model.to_s.camelize
        model_class = model_name.constantize

        graphql_name "#{model_name}RansackInputType"
        description "Ransack search query filters for #{model_name}"

        # Search matchers
        model_class.ransackable_attributes.each do |attr|
          Ransack::Configuration.predicates.instance_variable_get(:@collection).each do |predicate, value|
            argument "#{attr}_#{predicate}".to_sym,
                     value.wants_array ? [String] : String,
                     required: false, camelize: false
          end
        end

        # Sort matchers
        %i[s sorts].each do |sort_key|
          argument sort_key, String, required: false, camelize: false
        end
      end
    end
  end
end
