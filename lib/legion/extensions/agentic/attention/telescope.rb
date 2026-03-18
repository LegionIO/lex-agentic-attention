# frozen_string_literal: true

require 'securerandom'

require_relative 'telescope/version'
require_relative 'telescope/helpers/constants'
require_relative 'telescope/helpers/telescope'
require_relative 'telescope/helpers/observation'
require_relative 'telescope/helpers/observatory_engine'
require_relative 'telescope/runners/cognitive_telescope'
require_relative 'telescope/client'

module Legion
  module Extensions
    module Agentic
      module Attention
        module Telescope
        end
      end
    end
  end
end
