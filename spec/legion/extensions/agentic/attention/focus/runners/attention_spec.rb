# frozen_string_literal: true

RSpec.describe Legion::Extensions::Agentic::Attention::Focus::Runners::Attention do
  let(:client) { Legion::Extensions::Agentic::Attention::Focus::Client.new }

  describe '#filter_signals' do
    it 'returns empty result for empty input' do
      result = client.filter_signals(signals: [])
      expect(result[:filtered]).to eq([])
      expect(result[:spotlight]).to eq(0)
      expect(result[:peripheral]).to eq(0)
      expect(result[:background]).to eq(0)
      expect(result[:dropped]).to eq(0)
    end

    it 'categorizes high-salience signals as spotlight with goal boost' do
      signals = [{ salience: 0.9, domain: :terraform, novelty: 0.8 }]
      wonders = [{ domain: :terraform, salience: 0.9 }]
      result = client.filter_signals(signals: signals, active_wonders: wonders)
      expect(result[:spotlight]).to be >= 1
    end

    it 'categorizes high-salience signals into filtered output' do
      signals = [{ salience: 0.9, domain: :terraform, novelty: 0.8 }]
      result = client.filter_signals(signals: signals)
      expect(result[:filtered].size).to be >= 1
    end

    it 'deduplicates identical signals' do
      signals = [
        { salience: 0.8, domain: :terraform, source_type: :event, value: 'deploy' },
        { salience: 0.8, domain: :terraform, source_type: :event, value: 'deploy' }
      ]
      result = client.filter_signals(signals: signals)
      expect(result[:spotlight] + result[:peripheral] + result[:background]).to be <= 1
    end

    it 'preserves identical requests from different principals and frames' do
      request = { salience: 0.9, source_type: :human_direct, value: 'continue', channel_id: :cli }
      signals = [
        request.merge(principal_id: 'alice', frame_id: 'first'),
        request.merge(principal_id: 'bob', frame_id: 'second'),
        request.merge(principal_id: 'alice', frame_id: 'third')
      ]

      result = client.filter_signals(signals: signals + [signals.first.dup])

      expect(result[:filtered].map { |signal| signal[:frame_id] }).to contain_exactly('first', 'second', 'third')
    end

    it 'keeps requests from separate channels distinct when no frame identity is available' do
      request = { salience: 0.9, source_type: :human_direct, value: 'continue' }
      result = client.filter_signals(signals: [request.merge(channel_id: :cli), request.merge(channel_id: :slack)])

      expect(result[:filtered].map { |signal| signal[:channel_id] }).to contain_exactly(:cli, :slack)
    end

    it 'prioritizes signals within both retained tiers below the capacity limit' do
      signals = [
        { value: 'spotlight-low', salience: 0.8, novelty: 0.8, domain: :deploy },
        { value: 'spotlight-high', salience: 1.0, novelty: 1.0, domain: :incident },
        { value: 'peripheral-low', salience: 0.7, novelty: 0.5, domain: :status },
        { value: 'peripheral-high', salience: 0.9, novelty: 0.5, domain: :review }
      ]
      wonders = [{ domain: :deploy, salience: 1.0 }, { domain: :incident, salience: 1.0 }]

      result = client.filter_signals(signals: signals, active_wonders: wonders)

      expect(result[:filtered].map { |signal| signal[:value] })
        .to eq(%w[spotlight-high spotlight-low peripheral-high peripheral-low])
    end

    it 'enforces attentional capacity' do
      signals = Array.new(10) { |i| { salience: 0.9, domain: :"domain_#{i}", novelty: 0.9 } }
      result = client.filter_signals(signals: signals)
      expect(result[:spotlight]).to be <= Legion::Extensions::Agentic::Attention::Focus::Helpers::Constants::ATTENTIONAL_CAPACITY
    end
  end

  describe '#attention_status' do
    it 'returns status hash' do
      status = client.attention_status
      expect(status[:manual_focus]).to eq({})
      expect(status[:habituated_domains]).to eq([])
      expect(status[:capacity]).to eq(Legion::Extensions::Agentic::Attention::Focus::Helpers::Constants::ATTENTIONAL_CAPACITY)
      expect(status[:focus_count]).to eq(0)
    end
  end

  describe '#focus_on' do
    it 'focuses on a domain' do
      result = client.focus_on(domain: :terraform, reason: 'deployment')
      expect(result[:status]).to eq(:focused)
      expect(result[:domain]).to eq(:terraform)
    end

    it 'updates attention status' do
      client.focus_on(domain: :security, reason: 'incident')
      status = client.attention_status
      expect(status[:focus_count]).to eq(1)
    end
  end

  describe '#release_focus' do
    it 'releases a focused domain' do
      client.focus_on(domain: :terraform)
      result = client.release_focus(domain: :terraform)
      expect(result[:status]).to eq(:released)
    end

    it 'returns :not_focused for unknown domain' do
      result = client.release_focus(domain: :unknown)
      expect(result[:status]).to eq(:not_focused)
    end
  end

  describe '#habituation_stats' do
    it 'returns stats hash' do
      stats = client.habituation_stats
      expect(stats[:domains]).to be_a(Hash)
      expect(stats[:habituated]).to be_an(Array)
    end

    it 'reflects domain exposure after filtering' do
      signals = [{ salience: 0.8, domain: :terraform, novelty: 0.3 }]
      5.times { client.filter_signals(signals: signals) }
      stats = client.habituation_stats
      expect(stats[:domains]).to have_key(:terraform)
    end
  end
end
