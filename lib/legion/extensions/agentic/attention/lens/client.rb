# frozen_string_literal: true

require 'legion/extensions/agentic/attention/lens/helpers/constants'
require 'legion/extensions/agentic/attention/lens/helpers/lens'
require 'legion/extensions/agentic/attention/lens/helpers/lens_stack'
require 'legion/extensions/agentic/attention/lens/helpers/lens_engine'
require 'legion/extensions/agentic/attention/lens/runners/cognitive_lens'

module Legion
  module Extensions
    module Agentic
      module Attention
        module Lens
          class Client
            include Runners::CognitiveLens

            def initialize(**)
              @lens_engine = Helpers::LensEngine.new
            end

            private

            attr_reader :lens_engine
          end
        end
      end
    end
  end
end
