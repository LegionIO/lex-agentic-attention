# Changelog

## [0.1.7] - 2026-04-22
### Fixed
- Renamed Economy `attention_status` to `attention_economy_status` to resolve method collision with Focus
- Renamed Spotlight `release_focus` to `release_spotlight` to resolve method collision with Focus
### Added
- 5 new maintenance actors: Salience::Compute (12s), Arousal::Update (30s), SignalDetection::Update (60s), Regulation::Update (60s), Blink::Decay (15s)
- `decay_blink` method for attentional blink recovery

## [0.1.6] - 2026-04-15
### Changed
- Set `mcp_tools?`, `mcp_tools_deferred?`, and `transport_required?` to `false` — internal cognitive pipeline extension

## [0.1.5] - 2026-03-30

### Changed
- update to rubocop-legion 0.1.7, resolve all offenses

## [0.1.4] - 2026-03-26

### Changed
- fix remote_invocable? to use class method for local dispatch

## [0.1.3] - 2026-03-22

### Changed
- Add 7 runtime sub-gem dependencies to gemspec (legion-cache, legion-crypt, legion-data, legion-json, legion-logging, legion-settings, legion-transport)
- Replace spec_helper stubs with real sub-gem helper requires and real Helpers::Lex module

## [0.1.2] - 2026-03-18

### Changed
- Enforce TASK_SET_TYPES validation in SwitchingEngine#register_task (returns nil for invalid task_type)
- Enforce INPUT_TYPES validation in RelevanceEngine#submit_input (returns nil for invalid input_type)
- Enforce EFFECT_TYPES validation in RelevanceEngine#submit_input (returns nil for invalid effect_type)
- ATTENTION_MODES and TARGET_STATES in Regulation skipped: internally computed by state machine, not external input params

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
