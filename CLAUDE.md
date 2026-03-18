# lex-agentic-attention

**Parent**: `/Users/miverso2/rubymine/legion/extensions-agentic/CLAUDE.md`

## What Is This Gem?

Domain consolidation gem for attention, perception, and signal processing. Bundles 24 source extensions into one loadable unit under `Legion::Extensions::Agentic::Attention`.

**Gem**: `lex-agentic-attention`
**Version**: 0.1.2
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

## Tick Integration

`Attention::Focus` maps to the `sensory_processing` tick phase via `filter_signals`.

## Development

```bash
bundle install
bundle exec rspec        # 2288 examples, 0 failures
bundle exec rubocop      # 0 offenses
```
