# frozen_string_literal: true

require 'legion/extensions/agentic/attention/economy/helpers/constants'
require 'legion/extensions/agentic/attention/economy/helpers/demand'
require 'legion/extensions/agentic/attention/economy/helpers/attention_budget'
require 'legion/extensions/agentic/attention/economy/runners/attention_economy'

module Legion
  module Extensions
    module Agentic
      module Attention
        module Economy
          class Client
            include Runners::AttentionEconomy

            def initialize(**)
              @attention_budget = Helpers::AttentionBudget.new
            end

            private

            attr_reader :attention_budget
          end
        end
      end
    end
  end
end
