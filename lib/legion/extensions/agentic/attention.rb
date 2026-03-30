# frozen_string_literal: true

require_relative 'attention/version'
require_relative 'attention/focus'
require_relative 'attention/economy'
require_relative 'attention/regulation'
require_relative 'attention/schema'
require_relative 'attention/spotlight'
require_relative 'attention/switching'
require_relative 'attention/blink'
require_relative 'attention/telescope'
require_relative 'attention/lens'
require_relative 'attention/prism'
require_relative 'attention/lighthouse'
require_relative 'attention/blindspot'
require_relative 'attention/kaleidoscope'
require_relative 'attention/synesthesia'
require_relative 'attention/arousal'
require_relative 'attention/salience'
require_relative 'attention/sensory_gating'
require_relative 'attention/signal_detection'
require_relative 'attention/subliminal'
require_relative 'attention/latent_inhibition'
require_relative 'attention/surprise'
require_relative 'attention/relevance_theory'
require_relative 'attention/priming'
require_relative 'attention/feature_binding'

module Legion
  module Extensions
    module Agentic
      module Attention
        extend Legion::Extensions::Core if Legion::Extensions.const_defined? :Core, false

        def self.remote_invocable?
          false
        end
      end
    end
  end
end
