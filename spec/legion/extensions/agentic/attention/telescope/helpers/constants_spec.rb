# frozen_string_literal: true

RSpec.describe Legion::Extensions::Agentic::Attention::Telescope::Helpers::Constants do
  describe 'LENS_TYPES' do
    it 'contains expected lens types' do
      expect(described_class::LENS_TYPES).to include(:refractor, :reflector, :catadioptric, :radio, :adaptive)
    end

    it 'is frozen' do
      expect(described_class::LENS_TYPES).to be_frozen
    end
  end

  describe 'OBSERVATION_MODES' do
    it 'contains expected modes' do
      expect(described_class::OBSERVATION_MODES).to include(:survey, :focused, :tracking, :spectral)
    end

    it 'is frozen' do
      expect(described_class::OBSERVATION_MODES).to be_frozen
    end
  end

  describe 'numeric constants' do
    it 'MAX_TELESCOPES is 100' do
      expect(described_class::MAX_TELESCOPES).to eq(100)
    end

    it 'MAX_OBSERVATIONS is 500' do
      expect(described_class::MAX_OBSERVATIONS).to eq(500)
    end

    it 'BASE_MAGNIFICATION is 1.0' do
      expect(described_class::BASE_MAGNIFICATION).to eq(1.0)
    end

    it 'MAX_MAGNIFICATION is 100.0' do
      expect(described_class::MAX_MAGNIFICATION).to eq(100.0)
    end

    it 'FIELD_OF_VIEW_BASE is 1.0' do
      expect(described_class::FIELD_OF_VIEW_BASE).to eq(1.0)
    end

    it 'ATMOSPHERIC_DISTORTION is 0.1' do
      expect(described_class::ATMOSPHERIC_DISTORTION).to eq(0.1)
    end
  end

  describe 'CLARITY_LABELS' do
    it 'is an array of range-label pairs' do
      expect(described_class::CLARITY_LABELS).to be_an(Array)
      described_class::CLARITY_LABELS.each do |pair|
        expect(pair.size).to eq(2)
        expect(pair.first).to be_a(Range)
        expect(pair.last).to be_a(Symbol)
      end
    end

    it 'includes crystal, clear, hazy, blurry, blind labels' do
      labels = described_class::CLARITY_LABELS.map(&:last)
      expect(labels).to include(:crystal, :clear, :hazy, :blurry, :blind)
    end
  end

  describe 'DISTANCE_LABELS' do
    it 'is an array of range-label pairs' do
      expect(described_class::DISTANCE_LABELS).to be_an(Array)
    end

    it 'includes cosmic, deep, medium, near, myopic labels' do
      labels = described_class::DISTANCE_LABELS.map(&:last)
      expect(labels).to include(:cosmic, :deep, :medium, :near, :myopic)
    end
  end

  describe '.label_for' do
    it 'returns :crystal for high clarity' do
      result = described_class.label_for(described_class::CLARITY_LABELS, 0.95)
      expect(result).to eq(:crystal)
    end

    it 'returns :blind for very low clarity' do
      result = described_class.label_for(described_class::CLARITY_LABELS, 0.1)
      expect(result).to eq(:blind)
    end

    it 'returns :clear for mid-high clarity' do
      result = described_class.label_for(described_class::CLARITY_LABELS, 0.75)
      expect(result).to eq(:clear)
    end

    it 'returns :cosmic for high distance' do
      result = described_class.label_for(described_class::DISTANCE_LABELS, 0.9)
      expect(result).to eq(:cosmic)
    end

    it 'returns :myopic for very low distance' do
      result = described_class.label_for(described_class::DISTANCE_LABELS, 0.05)
      expect(result).to eq(:myopic)
    end

    it 'returns last label as fallback' do
      result = described_class.label_for(described_class::CLARITY_LABELS, -999.0)
      expect(result).to eq(described_class::CLARITY_LABELS.last.last)
    end
  end
end
