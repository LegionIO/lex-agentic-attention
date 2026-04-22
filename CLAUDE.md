# lex-agentic-attention

**Parent**: `../CLAUDE.md`

## What Is This Gem?

Domain consolidation gem for attention, perception, and signal processing. Bundles 24 source extensions into one loadable unit under `Legion::Extensions::Agentic::Attention`.

**Gem**: `lex-agentic-attention`
**Version**: 0.1.7
**Namespace**: `Legion::Extensions::Agentic::Attention`

## Sub-Modules

| Sub-Module | Source Gem | Purpose |
|---|---|---|
| `Attention::Focus` | `lex-attention` | Selective attention filter — Miller's Law (7±2), habituation, goal-directed amplification |
| `Attention::Economy` | `lex-attention-economy` | Attention as scarce resource — allocation budgets, ROI tracking |
| `Attention::Regulation` | `lex-attention-regulation` | Top-down and bottom-up attention regulation |
| `Attention::Schema` | `lex-attention-schema` | Self-model of the attention system itself |
| `Attention::Spotlight` | `lex-attention-spotlight` | Spotlight metaphor — illumination radius, dimmer control |
| `Attention::Switching` | `lex-attention-switching` | Voluntary/involuntary attention shifts, switch cost tracking |
| `Attention::Blink` | `lex-attentional-blink` | Rapid succession signal suppression — temporal attention limits |
| `Attention::Telescope` | `lex-cognitive-telescope` | Long-range attentional focus |
| `Attention::Lens` | `lex-cognitive-lens` | Attentional focus shaping |
| `Attention::Prism` | `lex-cognitive-prism` | Multi-spectrum signal decomposition |
| `Attention::Lighthouse` | `lex-cognitive-lighthouse` | Beacon-based attentional guidance |
| `Attention::Blindspot` | `lex-cognitive-blindspot` | Attentional blind spots and gaps |
| `Attention::Kaleidoscope` | `lex-cognitive-kaleidoscope` | Multi-faceted attentional patterns |
| `Attention::Synesthesia` | `lex-cognitive-synesthesia` | Cross-modal attentional blending |
| `Attention::Arousal` | `lex-arousal` | Yerkes-Dodson inverted-U — optimal performance at moderate arousal |
| `Attention::Salience` | `lex-salience` | Weighted integration from eight cognitive sources |
| `Attention::SensoryGating` | `lex-sensory-gating` | Pre-attentive filtering of redundant stimuli (P50 model) |
| `Attention::SignalDetection` | `lex-signal-detection` | SDT modeling — sensitivity (d'), response bias (beta) |
| `Attention::Subliminal` | `lex-subliminal` | Below-threshold signal processing |
| `Attention::LatentInhibition` | `lex-latent-inhibition` | Learned irrelevance — reduced processing of previously irrelevant stimuli |
| `Attention::Surprise` | `lex-surprise` | Surprise signal computation from violated expectations |
| `Attention::RelevanceTheory` | `lex-relevance-theory` | Cognitive effort vs. contextual effect optimization |
| `Attention::Priming` | `lex-priming` | Prior exposure boosts related processing |
| `Attention::FeatureBinding` | `lex-feature-binding` | Binding separately-processed features into unified percepts |

## Key Runner Methods

### `Focus::Runners::Attention`

| Method | Key Args | Returns |
|--------|----------|---------|
| `filter_signals` | `signals: [], active_wonders: []` | `{ filtered:, spotlight:, peripheral:, background:, dropped: }` |
| `attention_status` | — | `{ manual_focus:, habituated_domains:, habituation_stats:, capacity:, focus_count: }` |
| `focus_on` | `domain:, reason:` | `{ status:, domain: }` |
| `release_focus` | `domain:` | `{ status:, domain: }` |
| `habituation_stats` | — | `{ domains:, habituated: }` |

### `Economy::Runners::AttentionEconomy`

| Method | Key Args | Returns |
|--------|----------|---------|
| `add_demand` | `label:, demand_type:, priority:, cost:, roi:` | `{ created:, demand: }` |
| `allocate_demand` | `demand_id:, amount:` | allocation result |
| `deallocate_demand` | `demand_id:` | `{ freed: }` |
| `recover_budget` | `amount:` | `{ recovered:, spent: }` |
| `prioritized_demands` | — | `{ demands:, count: }` |
| `best_roi_demands` | `limit: 5` | `{ demands:, count: }` |
| `rebalance_budget` | — | `{ rebalanced:, spent: }` |
| `attention_economy_status` | — | budget report hash |
| `attention_snapshot` | — | full budget state hash |

### `Spotlight::Runners::AttentionSpotlight`

| Method | Key Args | Returns |
|--------|----------|---------|
| `register_target` | `label:, domain:, salience:, relevance:` | `{ success:, registered:, ... }` |
| `focus_spotlight` | `target_id:` | `{ success:, focused:, ... }` |
| `broaden_spotlight` | — | spotlight state |
| `narrow_spotlight` | — | spotlight state |
| `scan_targets` | — | scan result |
| `check_peripheral` | — | peripheral result |
| `check_capture` | — | capture check result |
| `release_spotlight` | — | `{ success:, ... }` |
| `spotlight_report` | — | full report |
| `most_salient` | `limit: 5` | `{ targets:, count: }` |
| `spotlight_state` | — | full state hash |

## Actors

| Actor | Interval | Target Method |
|-------|----------|---------------|
| `Arousal::Actor::Update` | Every 30s | `update_arousal` on `Arousal::Runners::Arousal` |
| `Blink::Actor::Decay` | Every 15s | `decay_blink` on `Blink::Runners::AttentionalBlink` |
| `FeatureBinding::Actors::Decay` | Every (interval) | `decay_bindings` on `FeatureBinding::Runners::FeatureBinding` |
| `Regulation::Actor::Update` | Every 60s | `update_attention` on `Regulation::Runners::AttentionRegulation` |
| `Salience::Actor::Compute` | Every 12s | `compute_salience` on `Salience::Runners::Salience` |
| `Schema::Actor::Decay` | Every 30s | `decay_schema` on `Schema::Runners::AttentionSchema` |
| `SignalDetection::Actor::Update` | Every 60s | `update_signal_detection` on `SignalDetection::Runners::SignalDetection` |

## Tick Integration

`Attention::Focus` maps to the `sensory_processing` tick phase via `filter_signals`. Returns `{ filtered:, spotlight:, peripheral:, background:, dropped: }` which is also read by `Core::Runners::Homeostasis#regulate` via `:sensory_processing` in `tick_results`.

## Dependencies

**Runtime** (from gemspec):
- `legion-cache` >= 1.3.11
- `legion-crypt` >= 1.4.9
- `legion-data` >= 1.4.17
- `legion-json` >= 1.2.1
- `legion-logging` >= 1.3.2
- `legion-settings` >= 1.3.14
- `legion-transport` >= 1.3.9

## Development

```bash
bundle install
bundle exec rspec        # 2288 examples, 0 failures
bundle exec rubocop      # 0 offenses
```
