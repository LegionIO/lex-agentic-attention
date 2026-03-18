# frozen_string_literal: true

require 'legion/extensions/agentic/attention/spotlight/helpers/constants'
require 'legion/extensions/agentic/attention/spotlight/helpers/attention_target'
require 'legion/extensions/agentic/attention/spotlight/helpers/spotlight'
require 'legion/extensions/agentic/attention/spotlight/helpers/spotlight_engine'
require 'legion/extensions/agentic/attention/spotlight/runners/attention_spotlight'

module Legion
  module Extensions
    module Agentic
      module Attention
        module Spotlight
          class Client
            include Runners::AttentionSpotlight

            def initialize(engine: nil, **)
              @engine = engine || Helpers::SpotlightEngine.new
            end

            private

            attr_reader :engine
          end
        end
      end
    end
  end
end
