# lex-agentic-attention

Domain consolidation gem for attention, perception, and signal processing. Bundles 24 source extensions into one loadable unit under `Legion::Extensions::Agentic::Attention`.

## Overview

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

## Actors

| Actor | Interval | What It Does |
|-------|----------|--------------|
| `Arousal::Actor::Update` | Every 30s | Updates arousal level using Yerkes-Dodson model |
| `Blink::Actor::Decay` | Every 15s | Decays attentional blink suppression window |
| `FeatureBinding::Actors::Decay` | interval | Decays bound feature groups |
| `Regulation::Actor::Update` | Every 60s | Applies top-down/bottom-up regulation updates |
| `Salience::Actor::Compute` | Every 12s | Recomputes salience map from all eight sources |
| `Schema::Actor::Decay` | Every 30s | Decays attention schema entries |
| `SignalDetection::Actor::Update` | Every 60s | Updates SDT sensitivity (d') and response bias (beta) |

## Installation

```ruby
gem 'lex-agentic-attention'
```

## Usage

```ruby
require 'legion/extensions/agentic/attention'

# Filter incoming signals through the attention focus system
client = Legion::Extensions::Agentic::Attention::Focus::Client.new
result = client.filter_signals(signals: incoming, active_wonders: goals)
# => { filtered: [...], spotlight: 3, peripheral: 2, background: 5, dropped: 1 }

# Check attention economy status
economy = Legion::Extensions::Agentic::Attention::Economy::Client.new
economy.attention_economy_status
# => { total_budget:, spent:, available:, utilization:, demand_count:, ... }

# Focus the spotlight on a specific target
spotlight = Legion::Extensions::Agentic::Attention::Spotlight::Client.new
spotlight.register_target(label: 'critical_alert', domain: :safety, salience: 0.9, relevance: 0.9)
spotlight.focus_spotlight(target_id: '<id>')
spotlight.release_spotlight
```

## Development

```bash
bundle install
bundle exec rspec        # 2288 examples, 0 failures
bundle exec rubocop      # 0 offenses
```

## License

MIT
