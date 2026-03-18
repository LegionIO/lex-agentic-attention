# frozen_string_literal: true

RSpec.describe Legion::Extensions::Agentic::Attention::Telescope::Runners::CognitiveTelescope do
  let(:engine) { Legion::Extensions::Agentic::Attention::Telescope::Helpers::ObservatoryEngine.new }

  describe '.create_telescope' do
    it 'returns success with telescope hash' do
      result = described_class.create_telescope(lens_type: :refractor, engine: engine)
      expect(result[:success]).to be true
      expect(result[:telescope][:lens_type]).to eq(:refractor)
    end

    it 'returns failure for invalid lens type' do
      result = described_class.create_telescope(lens_type: :laser_cannon, engine: engine)
      expect(result[:success]).to be false
      expect(result[:error]).to match(/unknown lens type/)
    end

    it 'passes custom aperture and magnification' do
      result = described_class.create_telescope(
        lens_type: :adaptive, aperture: 0.9, magnification: 10.0, engine: engine
      )
      expect(result[:telescope][:aperture]).to eq(0.9)
      expect(result[:telescope][:magnification]).to eq(10.0)
    end

    it 'accepts tracking option' do
      result = described_class.create_telescope(lens_type: :radio, tracking: true, engine: engine)
      expect(result[:telescope][:tracking]).to be true
    end
  end

  describe '.zoom_in' do
    it 'returns success after zoom in' do
      t = engine.create_telescope(lens_type: :reflector)
      result = described_class.zoom_in(telescope_id: t.id, factor: 5.0, engine: engine)
      expect(result[:success]).to be true
      expect(result[:telescope][:magnification]).to eq(5.0)
    end

    it 'returns failure for unknown telescope' do
      result = described_class.zoom_in(telescope_id: 'nope', factor: 2.0, engine: engine)
      expect(result[:success]).to be false
      expect(result[:error]).to match(/telescope not found/)
    end

    it 'uses default factor of 2.0' do
      t = engine.create_telescope(lens_type: :refractor)
      result = described_class.zoom_in(telescope_id: t.id, engine: engine)
      expect(result[:success]).to be true
      expect(result[:telescope][:magnification]).to eq(2.0)
    end
  end

  describe '.zoom_out' do
    it 'returns success after zoom out' do
      t = engine.create_telescope(lens_type: :catadioptric, magnification: 20.0)
      result = described_class.zoom_out(telescope_id: t.id, factor: 4.0, engine: engine)
      expect(result[:success]).to be true
      expect(result[:telescope][:magnification]).to eq(5.0)
    end

    it 'returns failure for unknown telescope' do
      result = described_class.zoom_out(telescope_id: 'nope', factor: 2.0, engine: engine)
      expect(result[:success]).to be false
    end
  end

  describe '.observe' do
    it 'returns success with observation hash' do
      t = engine.create_telescope(lens_type: :radio)
      result = described_class.observe(telescope_id: t.id, target: 'Mars', distance: 0.4, engine: engine)
      expect(result[:success]).to be true
      expect(result[:observation][:target]).to eq('Mars')
    end

    it 'returns failure for unknown telescope' do
      result = described_class.observe(telescope_id: 'nope', target: 'x', distance: 0.5, engine: engine)
      expect(result[:success]).to be false
    end

    it 'defaults distance to 0.5' do
      t = engine.create_telescope(lens_type: :refractor)
      result = described_class.observe(telescope_id: t.id, target: 'Venus', engine: engine)
      expect(result[:observation][:distance]).to eq(0.5)
    end
  end

  describe '.focus' do
    it 'returns success with updated telescope' do
      t = engine.create_telescope(lens_type: :adaptive)
      result = described_class.focus(telescope_id: t.id, target_distance: 0.7, engine: engine)
      expect(result[:success]).to be true
      expect(result[:telescope][:focal_distance]).to eq(0.7)
    end

    it 'returns failure for unknown telescope' do
      result = described_class.focus(telescope_id: 'x', target_distance: 0.5, engine: engine)
      expect(result[:success]).to be false
    end
  end

  describe '.survey_mode' do
    it 'resets telescope to wide-field mode' do
      t = engine.create_telescope(lens_type: :reflector, magnification: 50.0)
      result = described_class.survey_mode(telescope_id: t.id, engine: engine)
      expect(result[:success]).to be true
      expect(result[:telescope][:magnification]).to eq(1.0)
    end

    it 'returns failure for unknown telescope' do
      result = described_class.survey_mode(telescope_id: 'x', engine: engine)
      expect(result[:success]).to be false
    end
  end

  describe '.deep_focus' do
    it 'zooms telescope to maximum magnification' do
      t = engine.create_telescope(lens_type: :refractor)
      result = described_class.deep_focus(telescope_id: t.id, engine: engine)
      expect(result[:success]).to be true
      expect(result[:telescope][:magnification]).to eq(100.0)
    end

    it 'returns failure for unknown telescope' do
      result = described_class.deep_focus(telescope_id: 'x', engine: engine)
      expect(result[:success]).to be false
    end
  end

  describe '.list_observations' do
    it 'returns all observations' do
      t = engine.create_telescope(lens_type: :radio)
      engine.observe(telescope_id: t.id, target: 'a', distance: 0.1)
      engine.observe(telescope_id: t.id, target: 'b', distance: 0.2)
      result = described_class.list_observations(engine: engine)
      expect(result[:success]).to be true
      expect(result[:count]).to eq(2)
    end

    it 'filters to significant only when requested' do
      # high magnification + low distance = significant
      t = engine.create_telescope(lens_type: :adaptive, magnification: 100.0)
      engine.observe(telescope_id: t.id, target: 'close', distance: 0.05)
      # low magnification + far distance = faint
      t2 = engine.create_telescope(lens_type: :radio, magnification: 1.0)
      engine.observe(telescope_id: t2.id, target: 'far', distance: 0.95)
      result = described_class.list_observations(engine: engine, significant_only: true)
      expect(result[:count]).to be < 2
      expect(result[:observations].all? { |o| o[:significant] }).to be true
    end

    it 'returns empty list when no observations' do
      result = described_class.list_observations(engine: engine)
      expect(result[:count]).to eq(0)
      expect(result[:observations]).to be_empty
    end
  end

  describe '.observatory_status' do
    it 'returns a success report' do
      result = described_class.observatory_status(engine: engine)
      expect(result[:success]).to be true
      expect(result[:report]).to have_key(:total_telescopes)
    end

    it 'report reflects current state' do
      engine.create_telescope(lens_type: :refractor)
      result = described_class.observatory_status(engine: engine)
      expect(result[:report][:total_telescopes]).to eq(1)
    end
  end

  describe 'extra keyword arguments (**) splat' do
    it 'ignores extra kwargs on create_telescope' do
      result = described_class.create_telescope(
        lens_type: :radio, engine: engine, extra_param: 'ignored'
      )
      expect(result[:success]).to be true
    end

    it 'ignores extra kwargs on observe' do
      t = engine.create_telescope(lens_type: :radio)
      result = described_class.observe(
        telescope_id: t.id, target: 'test', distance: 0.3,
        engine: engine, unused: true
      )
      expect(result[:success]).to be true
    end
  end
end
