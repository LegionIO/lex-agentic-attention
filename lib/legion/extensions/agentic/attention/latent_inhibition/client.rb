# frozen_string_literal: true

require 'legion/extensions/agentic/attention/latent_inhibition/helpers/constants'
require 'legion/extensions/agentic/attention/latent_inhibition/helpers/stimulus_record'
require 'legion/extensions/agentic/attention/latent_inhibition/helpers/inhibition_engine'
require 'legion/extensions/agentic/attention/latent_inhibition/runners/latent_inhibition'

module Legion
  module Extensions
    module Agentic
      module Attention
        module LatentInhibition
          class Client
            include Runners::LatentInhibition

            def initialize(**)
              @default_engine = Helpers::InhibitionEngine.new
            end

            private

            attr_reader :default_engine
          end
        end
      end
    end
  end
end
