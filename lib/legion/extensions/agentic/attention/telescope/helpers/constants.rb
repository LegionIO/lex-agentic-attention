# frozen_string_literal: true

module Legion
  module Extensions
    module Agentic
      module Attention
        module Telescope
          module Helpers
            module Constants
              # Available lens types for cognitive telescopes
              LENS_TYPES = %i[refractor reflector catadioptric radio adaptive].freeze

              # Observation modes
              OBSERVATION_MODES = %i[survey focused tracking spectral].freeze

              # Maximum telescopes in the observatory
              MAX_TELESCOPES = 100

              # Maximum recorded observations
              MAX_OBSERVATIONS = 500

              # Base and max magnification bounds
              BASE_MAGNIFICATION = 1.0
              MAX_MAGNIFICATION  = 100.0

              # Field of view base in radians (wide-open single radian)
              FIELD_OF_VIEW_BASE = 1.0

              # Atmospheric distortion coefficient (reduces clarity at low magnification)
              ATMOSPHERIC_DISTORTION = 0.1

              # Clarity labels (range-based, descending)
              CLARITY_LABELS = [
                [(0.85..),      :crystal],
                [(0.65...0.85), :clear],
                [(0.45...0.65), :hazy],
                [(0.25...0.45), :blurry],
                [..0.25,        :blind]
              ].freeze

              # Distance labels (range-based, descending)
              DISTANCE_LABELS = [
                [(0.85..),      :cosmic],
                [(0.65...0.85), :deep],
                [(0.4...0.65),  :medium],
                [(0.2...0.4),   :near],
                [..0.2,         :myopic]
              ].freeze

              def self.label_for(table, value)
                table.each { |range, label| return label if range.cover?(value) }
                table.last.last
              end
            end
          end
        end
      end
    end
  end
end
