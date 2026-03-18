# frozen_string_literal: true

module Legion
  module Extensions
    module Agentic
      module Attention
        module Telescope
          module Runners
            module CognitiveTelescope
              extend self

              include Legion::Extensions::Helpers::Lex if defined?(Legion::Extensions::Helpers::Lex)

              def create_telescope(lens_type:, aperture: 0.5, magnification: 1.0,
                                   tracking: false, engine: nil, **)
                eng   = resolve_engine(engine)
                scope = eng.create_telescope(
                  lens_type:     lens_type,
                  aperture:      aperture,
                  magnification: magnification,
                  tracking:      tracking
                )
                { success: true, telescope: scope.to_h }
              rescue ArgumentError => e
                { success: false, error: e.message }
              end

              def zoom_in(telescope_id:, factor: 2.0, engine: nil, **)
                eng   = resolve_engine(engine)
                scope = eng.zoom_in(telescope_id: telescope_id, factor: factor)
                { success: true, telescope: scope.to_h }
              rescue ArgumentError => e
                { success: false, error: e.message }
              end

              def zoom_out(telescope_id:, factor: 2.0, engine: nil, **)
                eng   = resolve_engine(engine)
                scope = eng.zoom_out(telescope_id: telescope_id, factor: factor)
                { success: true, telescope: scope.to_h }
              rescue ArgumentError => e
                { success: false, error: e.message }
              end

              def observe(telescope_id:, target:, distance: 0.5, engine: nil, **)
                eng = resolve_engine(engine)
                obs = eng.observe(telescope_id: telescope_id, target: target, distance: distance)
                { success: true, observation: obs.to_h }
              rescue ArgumentError => e
                { success: false, error: e.message }
              end

              def focus(telescope_id:, target_distance:, engine: nil, **)
                eng   = resolve_engine(engine)
                scope = eng.focus_telescope(telescope_id:    telescope_id,
                                            target_distance: target_distance)
                { success: true, telescope: scope.to_h }
              rescue ArgumentError => e
                { success: false, error: e.message }
              end

              def survey_mode(telescope_id:, engine: nil, **)
                eng   = resolve_engine(engine)
                scope = eng.survey_mode!(telescope_id: telescope_id)
                { success: true, telescope: scope.to_h }
              rescue ArgumentError => e
                { success: false, error: e.message }
              end

              def deep_focus(telescope_id:, engine: nil, **)
                eng   = resolve_engine(engine)
                scope = eng.deep_focus!(telescope_id: telescope_id)
                { success: true, telescope: scope.to_h }
              rescue ArgumentError => e
                { success: false, error: e.message }
              end

              def list_observations(engine: nil, significant_only: false, **)
                eng  = resolve_engine(engine)
                list = significant_only ? eng.significant_observations : eng.all_observations
                { success: true, observations: list.map(&:to_h), count: list.size }
              end

              def observatory_status(engine: nil, **)
                eng = resolve_engine(engine)
                { success: true, report: eng.observatory_report }
              end

              private

              def resolve_engine(engine)
                engine || default_engine
              end

              def default_engine
                @default_engine ||= Helpers::ObservatoryEngine.new
              end
            end
          end
        end
      end
    end
  end
end
