# frozen_string_literal: true

require 'legion/extensions/agentic/attention/arousal/helpers/constants'
require 'legion/extensions/agentic/attention/arousal/helpers/arousal_model'
require 'legion/extensions/agentic/attention/arousal/runners/arousal'

module Legion
  module Extensions
    module Agentic
      module Attention
        module Arousal
          class Client
            include Runners::Arousal

            def initialize(**)
              @arousal_model = Helpers::ArousalModel.new
            end

            private

            attr_reader :arousal_model
          end
        end
      end
    end
  end
end
