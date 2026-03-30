# frozen_string_literal: true

module Legion
  module Extensions
    module Agentic
      module Attention
        module LatentInhibition
          module Runners
            module LatentInhibition
              include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                          Legion::Extensions::Helpers.const_defined?(:Lex, false)

              def expose(label:, engine: nil, **)
                eng = engine || default_engine
                result = eng.expose_stimulus(label: label)

                log.debug("[latent_inhibition] expose: label=#{label} " \
                          "exposure_count=#{result[:exposure_count]} " \
                          "inhibition=#{result[:inhibition_score].round(4)} " \
                          "label=#{result[:inhibition_label]} novel=#{result[:novel]}")
                result
              end

              def associate(label:, outcome:, engine: nil, **)
                eng = engine || default_engine
                result = eng.attempt_association(label: label, outcome: outcome)

                log.debug("[latent_inhibition] associate: label=#{label} outcome=#{outcome} " \
                          "effectiveness=#{result[:effectiveness].round(4)} blocked=#{result[:blocked]}")
                result
              end

              def disinhibit(label:, intensity: 1.0, engine: nil, **)
                eng = engine || default_engine
                result = eng.disinhibit(label: label, intensity: intensity)

                log.debug("[latent_inhibition] disinhibit: label=#{label} " \
                          "prior=#{result[:prior_score]&.round(4)} new=#{result[:new_score]&.round(4)}")
                result
              end

              def novel_stimuli(engine: nil, **)
                eng = engine || default_engine
                stimuli = eng.novel_stimuli

                log.debug("[latent_inhibition] novel_stimuli: count=#{stimuli.size}")
                { stimuli: stimuli, count: stimuli.size }
              end

              def most_inhibited(limit: 10, engine: nil, **)
                eng = engine || default_engine
                stimuli = eng.most_inhibited(limit: limit)

                log.debug("[latent_inhibition] most_inhibited: limit=#{limit} returned=#{stimuli.size}")
                { stimuli: stimuli, count: stimuli.size }
              end

              def inhibition_report(engine: nil, **)
                eng = engine || default_engine
                report = eng.inhibition_report

                log.debug("[latent_inhibition] report: total=#{report[:total_stimuli]} " \
                          "novel=#{report[:novel_count]} mean=#{report[:mean_inhibition]&.round(4)}")
                report
              end

              private

              def default_engine
                @default_engine ||= Helpers::InhibitionEngine.new
              end
            end
          end
        end
      end
    end
  end
end
