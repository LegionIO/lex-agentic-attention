# frozen_string_literal: true

RSpec.describe Legion::Extensions::Agentic::Attention::SensoryGating::Helpers::GatingEngine do
  subject(:engine) { described_class.new }

  let(:filter) { engine.create_filter(modality: :visual) }

  describe '#create_filter' do
    it 'returns a SensoryFilter' do
      expect(filter).to be_a(Legion::Extensions::Agentic::Attention::SensoryGating::Helpers::SensoryFilter)
    end

    it 'stores the filter' do
      filter
      expect(engine.to_h[:total_filters]).to eq(1)
    end

    it 'rejects invalid modality' do
      result = engine.create_filter(modality: :nonexistent)
      expect(result).to be_nil
    end

    it 'accepts all valid MODALITY_TYPES' do
      constants = Legion::Extensions::Agentic::Attention::SensoryGating::Helpers::Constants
      constants::MODALITY_TYPES.each do |mod|
        f = engine.create_filter(modality: mod)
        expect(f).not_to be_nil
      end
      expect(engine.to_h[:total_filters]).to eq(constants::MODALITY_TYPES.size)
    end
  end

  describe '#process_stimulus' do
    it 'returns outcome and filter' do
      result = engine.process_stimulus(filter_id: filter.id, intensity: 0.9)
      expect(result[:outcome]).to eq(:passed)
    end

    it 'returns nil for unknown id' do
      expect(engine.process_stimulus(filter_id: 'fake', intensity: 0.5)).to be_nil
    end
  end

  describe '#open_gate' do
    it 'decreases filter threshold' do
      original = filter.gate_threshold
      engine.open_gate(filter_id: filter.id)
      expect(filter.gate_threshold).to be < original
    end
  end

  describe '#close_gate' do
    it 'increases filter threshold' do
      original = filter.gate_threshold
      engine.close_gate(filter_id: filter.id)
      expect(filter.gate_threshold).to be > original
    end
  end

  describe '#sensitize' do
    it 'returns the filter' do
      result = engine.sensitize(filter_id: filter.id)
      expect(result).to eq(filter)
    end
  end

  describe '#reset_habituation' do
    it 'resets habituation' do
      engine.process_stimulus(filter_id: filter.id, intensity: 0.9)
      engine.reset_habituation(filter_id: filter.id)
      expect(filter.habituation_level).to eq(0.0)
    end
  end

  describe '#filters_by_modality' do
    it 'filters by modality' do
      engine.create_filter(modality: :auditory)
      filter
      result = engine.filters_by_modality(modality: :auditory)
      expect(result.size).to eq(1)
    end
  end

  describe '#average_pass_rate' do
    it 'returns 0.0 with no filters' do
      fresh = described_class.new
      expect(fresh.average_pass_rate).to eq(0.0)
    end
  end

  describe '#most_restrictive' do
    it 'returns filters sorted by threshold descending' do
      engine.create_filter(modality: :visual, gate_threshold: 0.3)
      engine.create_filter(modality: :auditory, gate_threshold: 0.8)
      restrictive = engine.most_restrictive(limit: 1)
      expect(restrictive.first.gate_threshold).to eq(0.8)
    end
  end

  describe '#gating_report' do
    it 'includes all report fields' do
      filter
      report = engine.gating_report
      expect(report).to include(
        :total_filters, :average_pass_rate,
        :most_restrictive, :most_permissive
      )
    end
  end

  describe '#to_h' do
    it 'includes summary fields' do
      hash = engine.to_h
      expect(hash).to include(:total_filters, :average_pass_rate)
    end
  end

  describe 'pruning' do
    it 'prunes oldest filter when limit reached' do
      stub_const('Legion::Extensions::Agentic::Attention::SensoryGating::Helpers::Constants::MAX_FILTERS', 3)
      eng = described_class.new
      modalities = %i[visual auditory textual semantic]
      modalities.each { |m| eng.create_filter(modality: m) }
      expect(eng.to_h[:total_filters]).to eq(3)
    end
  end
end
