# frozen_string_literal: true

require 'legion/extensions/agentic/attention/synesthesia/helpers/constants'
require 'legion/extensions/agentic/attention/synesthesia/helpers/sensory_mapping'
require 'legion/extensions/agentic/attention/synesthesia/helpers/synesthetic_event'
require 'legion/extensions/agentic/attention/synesthesia/helpers/synesthesia_engine'
require 'legion/extensions/agentic/attention/synesthesia/runners/cognitive_synesthesia'

module Legion
  module Extensions
    module Agentic
      module Attention
        module Synesthesia
          class Client
            include Runners::CognitiveSynesthesia

            def initialize(engine: nil, **)
              @synesthesia_engine = engine || Helpers::SynesthesiaEngine.new
            end

            private

            attr_reader :synesthesia_engine
          end
        end
      end
    end
  end
end
