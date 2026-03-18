# frozen_string_literal: true

module Legion
  module Extensions
    module Agentic
      module Attention
        module Prism
          class Client
            include Runners::CognitivePrism

            attr_reader :engine

            def initialize(engine: nil, **)
              @engine         = engine || Helpers::PrismEngine.new
              @default_engine = @engine
            end

            private

            attr_writer :default_engine
          end
        end
      end
    end
  end
end
