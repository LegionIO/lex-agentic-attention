# frozen_string_literal: true

require_relative 'switching/version'
require_relative 'switching/helpers/constants'
require_relative 'switching/helpers/task_set'
require_relative 'switching/helpers/switch_event'
require_relative 'switching/helpers/switching_engine'
require_relative 'switching/runners/attention_switching'
require_relative 'switching/client'

module Legion
  module Extensions
    module Agentic
      module Attention
        module Switching
        end
      end
    end
  end
end
