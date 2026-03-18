# frozen_string_literal: true

require 'legion/extensions/agentic/attention/focus/helpers/constants'
require 'legion/extensions/agentic/attention/focus/helpers/focus'
require 'legion/extensions/agentic/attention/focus/helpers/focus_manager'
require 'legion/extensions/agentic/attention/focus/helpers/habituation'
require 'legion/extensions/agentic/attention/focus/runners/attention'

module Legion
  module Extensions
    module Agentic
      module Attention
        module Focus
          class Client
            include Runners::Attention

            def initialize(**)
              @focus_manager = Helpers::FocusManager.new
              @habituation_model = Helpers::Habituation.new
            end

            private

            attr_reader :focus_manager, :habituation_model
          end
        end
      end
    end
  end
end
