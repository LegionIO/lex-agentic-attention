# Changelog

## [Unreleased]

## [0.1.1] - 2026-03-18

### Changed
- Enforce FEATURE_DIMENSIONS validation in BindingField#register_feature (returns nil for invalid dimension)
- Enforce MODALITY_TYPES validation in GatingEngine#create_filter (returns nil for invalid modality)
- Enforce DISCOVERY_METHODS validation in BlindspotEngine#register_blindspot (returns nil for invalid discovered_by)

## [0.1.0] - 2026-03-18

### Added
- Initial release as domain consolidation gem
- Consolidated source extensions into unified domain gem under `Legion::Extensions::Agentic::<Domain>`
- All sub-modules loaded from single entry point
- Full spec suite with zero failures
- RuboCop compliance across all files
