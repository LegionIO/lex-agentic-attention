# frozen_string_literal: true

$LOADED_FEATURES << 'legion/extensions/actors/every' unless $LOADED_FEATURES.include?('legion/extensions/actors/every')
require 'legion/extensions/agentic/attention/blink/actors/decay'

RSpec.describe Legion::Extensions::Agentic::Attention::Blink::Actor::Decay do
  subject(:actor) { described_class.new }

  describe '#runner_class' do
    it 'points to the AttentionalBlink runner' do
      expect(actor.runner_class).to eq Legion::Extensions::Agentic::Attention::Blink::Runners::AttentionalBlink
    end
  end

  describe '#runner_function' do
    it 'is decay_blink' do
      expect(actor.runner_function).to eq 'decay_blink'
    end
  end

  describe '#time' do
    it 'runs every 15 seconds' do
      expect(actor.time).to eq 15
    end
  end

  describe '#run_now?' do
    it { expect(actor.run_now?).to be false }
  end

  describe '#use_runner?' do
    it { expect(actor.use_runner?).to be false }
  end

  describe '#check_subtask?' do
    it { expect(actor.check_subtask?).to be false }
  end

  describe '#generate_task?' do
    it { expect(actor.generate_task?).to be false }
  end
end
