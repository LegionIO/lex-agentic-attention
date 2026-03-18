# frozen_string_literal: true

require 'legion/extensions/agentic/attention/schema/helpers/constants'
require 'legion/extensions/agentic/attention/schema/helpers/schema_item'
require 'legion/extensions/agentic/attention/schema/helpers/attention_schema_model'
require 'legion/extensions/agentic/attention/schema/runners/attention_schema'

module Legion
  module Extensions
    module Agentic
      module Attention
        module Schema
          class Client
            include Runners::AttentionSchema

            def initialize(schema_model: nil, **)
              @schema_model = schema_model || Helpers::AttentionSchemaModel.new
            end

            private

            attr_reader :schema_model
          end
        end
      end
    end
  end
end
