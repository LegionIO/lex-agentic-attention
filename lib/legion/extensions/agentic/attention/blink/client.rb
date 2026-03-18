# frozen_string_literal: true

module Legion
  module Extensions
    module Agentic
      module Attention
        module Blink
          class Client
            include Runners::AttentionalBlink

            def engine
              @engine ||= Helpers::BlinkEngine.new
            end
          end
        end
      end
    end
  end
end
