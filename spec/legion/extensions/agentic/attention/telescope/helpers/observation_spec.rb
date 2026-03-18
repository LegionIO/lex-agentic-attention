# frozen_string_literal: true

RSpec.describe Legion::Extensions::Agentic::Attention::Telescope::Helpers::Observation do
  let(:telescope_id) { SecureRandom.uuid }

  subject(:observation) do
    described_class.new(
      telescope_id:            telescope_id,
      target:                  'Alpha Centauri',
      distance:                0.5,
      telescope_magnification: 50.0
    )
  end

  describe '#initialize' do
    it 'generates a uuid id' do
      expect(observation.id).to match(/\A[0-9a-f-]{36}\z/)
    end

    it 'stores the telescope_id' do
      expect(observation.telescope_id).to eq(telescope_id)
    end

    it 'stores the target as string' do
      expect(observation.target).to eq('Alpha Centauri')
    end

    it 'stores the clamped distance' do
      expect(observation.distance).to eq(0.5)
    end

    it 'clamps distance above 1.0' do
      obs = described_class.new(telescope_id: telescope_id, target: 'x',
                                distance: 5.0, telescope_magnification: 10.0)
      expect(obs.distance).to eq(1.0)
    end

    it 'clamps distance below 0.0' do
      obs = described_class.new(telescope_id: telescope_id, target: 'x',
                                distance: -1.0, telescope_magnification: 10.0)
      expect(obs.distance).to eq(0.0)
    end

    it 'sets recorded_at' do
      expect(observation.recorded_at).to be_a(Time)
    end

    it 'computes a detail_level between 0 and 1' do
      expect(observation.detail_level).to be_between(0.0, 1.0)
    end
  end

  describe '#detail_level' do
    it 'is higher with greater magnification' do
      low_mag  = described_class.new(telescope_id: telescope_id, target: 'x',
                                     distance: 0.2, telescope_magnification: 10.0)
      high_mag = described_class.new(telescope_id: telescope_id, target: 'x',
                                     distance: 0.2, telescope_magnification: 90.0)
      expect(high_mag.detail_level).to be > low_mag.detail_level
    end

    it 'is higher for closer targets' do
      far   = described_class.new(telescope_id: telescope_id, target: 'x',
                                  distance: 0.9, telescope_magnification: 50.0)
      near  = described_class.new(telescope_id: telescope_id, target: 'x',
                                  distance: 0.1, telescope_magnification: 50.0)
      expect(near.detail_level).to be > far.detail_level
    end

    it 'is zero when at max distance with min magnification' do
      obs = described_class.new(telescope_id: telescope_id, target: 'x',
                                distance: 1.0, telescope_magnification: 1.0)
      expect(obs.detail_level).to eq(0.0)
    end
  end

  describe '#significant?' do
    it 'returns true when detail_level >= 0.7' do
      obs = described_class.new(telescope_id: telescope_id, target: 'x',
                                distance: 0.1, telescope_magnification: 100.0)
      expect(obs.significant?).to be true
    end

    it 'returns false when detail_level < 0.7' do
      obs = described_class.new(telescope_id: telescope_id, target: 'x',
                                distance: 0.9, telescope_magnification: 1.0)
      expect(obs.significant?).to be false
    end
  end

  describe '#faint?' do
    it 'returns true when detail_level < 0.3' do
      obs = described_class.new(telescope_id: telescope_id, target: 'x',
                                distance: 0.9, telescope_magnification: 1.0)
      expect(obs.faint?).to be true
    end

    it 'returns false for a well-resolved observation' do
      # high magnification + very close distance = high detail (not faint)
      obs = described_class.new(telescope_id: telescope_id, target: 'nearby',
                                distance: 0.05, telescope_magnification: 100.0)
      expect(obs.faint?).to be false
    end
  end

  describe '#distance_label' do
    it 'returns a symbol' do
      expect(observation.distance_label).to be_a(Symbol)
    end

    it 'returns :cosmic for very distant targets' do
      obs = described_class.new(telescope_id: telescope_id, target: 'x',
                                distance: 0.95, telescope_magnification: 10.0)
      expect(obs.distance_label).to eq(:cosmic)
    end

    it 'returns :myopic for very close targets' do
      obs = described_class.new(telescope_id: telescope_id, target: 'x',
                                distance: 0.05, telescope_magnification: 10.0)
      expect(obs.distance_label).to eq(:myopic)
    end
  end

  describe '#to_h' do
    it 'contains all expected keys' do
      h = observation.to_h
      %i[id telescope_id target distance distance_label
         detail_level significant faint recorded_at].each do |key|
        expect(h).to have_key(key)
      end
    end

    it 'serializes significant correctly' do
      h = observation.to_h
      expect(h[:significant]).to eq(observation.significant?)
    end
  end
end
