# frozen_string_literal: true

module Legion
  module Extensions
    module Agentic
      module Attention
        module Telescope
          module Helpers
            class Telescope
              attr_reader :id, :lens_type, :aperture, :magnification,
                          :tracking, :focal_distance, :created_at

              def initialize(lens_type:, aperture: 0.5, magnification: 1.0, tracking: false)
                validate_lens_type!(lens_type)
                @id            = SecureRandom.uuid
                @lens_type     = lens_type.to_sym
                @aperture      = aperture.to_f.clamp(0.1, 1.0).round(10)
                @magnification = magnification.to_f.clamp(
                  Constants::BASE_MAGNIFICATION, Constants::MAX_MAGNIFICATION
                ).round(10)
                @tracking = tracking
                @focal_distance = nil
                @created_at = Time.now.utc
              end

              # Increase magnification by factor; field of view narrows inversely
              def zoom_in!(factor)
                factor = factor.to_f.clamp(1.0, Constants::MAX_MAGNIFICATION)
                @magnification = (@magnification * factor).clamp(
                  Constants::BASE_MAGNIFICATION, Constants::MAX_MAGNIFICATION
                ).round(10)
                self
              end

              # Decrease magnification by factor; field of view widens
              def zoom_out!(factor)
                factor = [factor.to_f, 1.0].max
                @magnification = (@magnification / factor).clamp(
                  Constants::BASE_MAGNIFICATION, Constants::MAX_MAGNIFICATION
                ).round(10)
                self
              end

              # Calculated field of view: wider aperture + lower magnification = wider field
              def field_of_view
                (Constants::FIELD_OF_VIEW_BASE / @magnification * @aperture).round(10)
              end

              # Clarity based on aperture and atmospheric distortion modulated by magnification
              def clarity
                distortion_factor = 1.0 - (Constants::ATMOSPHERIC_DISTORTION / @magnification.clamp(1.0, 10.0))
                (@aperture * distortion_factor).clamp(0.0, 1.0).round(10)
              end

              # Focus on a target distance; focal alignment adjusts effective clarity
              def focus!(target_distance)
                @focal_distance = target_distance.to_f.clamp(0.0, 1.0).round(10)
                self
              end

              def enable_tracking!
                @tracking = true
                self
              end

              def disable_tracking!
                @tracking = false
                self
              end

              # True when magnification >= 50 (deep-sky mode)
              def deep_field?
                @magnification >= 50.0
              end

              # True when magnification <= 5 (wide-field survey mode)
              def wide_field?
                @magnification <= 5.0
              end

              # True when clarity is at or above 0.8
              def sharp?
                clarity >= 0.8
              end

              # True when clarity falls below 0.3
              def blurry?
                clarity < 0.3
              end

              def clarity_label
                Helpers::Constants.label_for(Constants::CLARITY_LABELS, clarity)
              end

              def to_h
                {
                  id:             @id,
                  lens_type:      @lens_type,
                  aperture:       @aperture,
                  magnification:  @magnification,
                  tracking:       @tracking,
                  focal_distance: @focal_distance,
                  field_of_view:  field_of_view,
                  clarity:        clarity,
                  clarity_label:  clarity_label,
                  deep_field:     deep_field?,
                  wide_field:     wide_field?,
                  sharp:          sharp?,
                  blurry:         blurry?,
                  created_at:     @created_at
                }
              end

              private

              def validate_lens_type!(val)
                return if Constants::LENS_TYPES.include?(val.to_sym)

                raise ArgumentError,
                      "unknown lens type: #{val.inspect}; " \
                      "must be one of #{Constants::LENS_TYPES.inspect}"
              end
            end
          end
        end
      end
    end
  end
end
