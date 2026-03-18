# frozen_string_literal: true

module Legion
  module Extensions
    module Agentic
      module Attention
        module Regulation
          class Client
            include Runners::AttentionRegulation

            def initialize(controller: nil)
              @controller = controller || Helpers::AttentionController.new
            end
          end
        end
      end
    end
  end
end
