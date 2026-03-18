# frozen_string_literal: true

module Legion
  module Extensions
    module Agentic
      module Attention
        module Telescope
          module Helpers
            class Observation
              attr_reader :id, :telescope_id, :target, :distance,
                          :detail_level, :recorded_at

              def initialize(telescope_id:, target:, distance:, telescope_magnification: 1.0)
                @id                   = SecureRandom.uuid
                @telescope_id         = telescope_id
                @target               = target.to_s
                @distance             = distance.to_f.clamp(0.0, 1.0).round(10)
                @detail_level         = compute_detail(telescope_magnification)
                @recorded_at          = Time.now.utc
              end

              # True when detail is strong enough to be actionable
              def significant?
                @detail_level >= 0.7
              end

              # True when detail is too faint to interpret
              def faint?
                @detail_level < 0.3
              end

              def distance_label
                Helpers::Constants.label_for(Constants::DISTANCE_LABELS, @distance)
              end

              def to_h
                {
                  id:             @id,
                  telescope_id:   @telescope_id,
                  target:         @target,
                  distance:       @distance,
                  distance_label: distance_label,
                  detail_level:   @detail_level,
                  significant:    significant?,
                  faint:          faint?,
                  recorded_at:    @recorded_at
                }
              end

              private

              # Higher magnification + closer distance = richer detail
              # Normalise magnification to 0..1 range relative to MAX_MAGNIFICATION
              def compute_detail(magnification)
                mag_factor = magnification.to_f.clamp(
                  Constants::BASE_MAGNIFICATION, Constants::MAX_MAGNIFICATION
                ) / Constants::MAX_MAGNIFICATION
                proximity   = 1.0 - @distance
                raw         = (mag_factor * proximity).clamp(0.0, 1.0)
                raw.round(10)
              end
            end
          end
        end
      end
    end
  end
end
