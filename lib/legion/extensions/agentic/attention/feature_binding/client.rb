# frozen_string_literal: true

require 'legion/extensions/agentic/attention/feature_binding/helpers/constants'
require 'legion/extensions/agentic/attention/feature_binding/helpers/feature'
require 'legion/extensions/agentic/attention/feature_binding/helpers/bound_object'
require 'legion/extensions/agentic/attention/feature_binding/helpers/binding_field'
require 'legion/extensions/agentic/attention/feature_binding/runners/feature_binding'

module Legion
  module Extensions
    module Agentic
      module Attention
        module FeatureBinding
          class Client
            include Runners::FeatureBinding

            def initialize(field: nil, **)
              @field = field || Helpers::BindingField.new
            end

            private

            attr_reader :field
          end
        end
      end
    end
  end
end
