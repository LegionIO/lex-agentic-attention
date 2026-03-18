# frozen_string_literal: true

module Legion
  module Extensions
    module Agentic
      module Attention
        module Lighthouse
          class Client
            include Runners::CognitiveLighthouse

            def initialize(engine: nil, **)
              @engine = engine || Helpers::LighthouseEngine.new
            end

            private

            def default_engine
              @engine
            end
          end
        end
      end
    end
  end
end
