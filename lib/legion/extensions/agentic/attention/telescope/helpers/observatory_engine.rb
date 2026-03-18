# frozen_string_literal: true

module Legion
  module Extensions
    module Agentic
      module Attention
        module Telescope
          module Helpers
            class ObservatoryEngine
              def initialize
                @telescopes   = {}
                @observations = []
              end

              # Create and register a new telescope
              def create_telescope(lens_type:, aperture: 0.5, magnification: 1.0, tracking: false)
                raise ArgumentError, 'observatory full' if @telescopes.size >= Constants::MAX_TELESCOPES

                scope = Telescope.new(
                  lens_type:     lens_type,
                  aperture:      aperture,
                  magnification: magnification,
                  tracking:      tracking
                )
                @telescopes[scope.id] = scope
                scope
              end

              # Zoom in on a telescope by multiplying magnification
              def zoom_in(telescope_id:, factor:)
                fetch_telescope(telescope_id).zoom_in!(factor)
              end

              # Zoom out on a telescope by dividing magnification
              def zoom_out(telescope_id:, factor:)
                fetch_telescope(telescope_id).zoom_out!(factor)
              end

              # Focus a telescope at a given target distance
              def focus_telescope(telescope_id:, target_distance:)
                fetch_telescope(telescope_id).focus!(target_distance)
              end

              # Record an observation for a target at a given distance
              def observe(telescope_id:, target:, distance:)
                raise ArgumentError, 'observation log full' if @observations.size >= Constants::MAX_OBSERVATIONS

                scope = fetch_telescope(telescope_id)
                obs   = Observation.new(
                  telescope_id:            scope.id,
                  target:                  target,
                  distance:                distance,
                  telescope_magnification: scope.magnification
                )
                @observations << obs
                obs
              end

              # Survey mode: zoom out to BASE_MAGNIFICATION (wide-field scan)
              def survey_mode!(telescope_id:)
                scope = fetch_telescope(telescope_id)
                scope.zoom_out!(scope.magnification)
                scope
              end

              # Deep-focus mode: zoom in to MAX_MAGNIFICATION
              def deep_focus!(telescope_id:)
                scope = fetch_telescope(telescope_id)
                scope.zoom_in!(Constants::MAX_MAGNIFICATION)
                scope
              end

              def all_telescopes
                @telescopes.values
              end

              def all_observations
                @observations.dup
              end

              def significant_observations
                @observations.select(&:significant?)
              end

              # Summary report for the observatory
              def observatory_report
                {
                  total_telescopes:    @telescopes.size,
                  total_observations:  @observations.size,
                  significant_count:   significant_observations.size,
                  faint_count:         @observations.count(&:faint?),
                  avg_detail:          avg_detail,
                  deepest_observation: deepest_observation,
                  widest_telescope:    widest_telescope
                }
              end

              private

              def fetch_telescope(id)
                @telescopes.fetch(id) do
                  raise ArgumentError, "telescope not found: #{id}"
                end
              end

              def avg_detail
                total = @observations.size
                return 0.0 if total.zero?

                (@observations.sum(&:detail_level) / total).round(10)
              end

              def deepest_observation
                @observations.max_by(&:distance)&.to_h
              end

              def widest_telescope
                @telescopes.values.min_by(&:magnification)&.to_h
              end
            end
          end
        end
      end
    end
  end
end
