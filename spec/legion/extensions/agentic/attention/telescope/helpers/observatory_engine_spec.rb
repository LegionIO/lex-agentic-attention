# frozen_string_literal: true

RSpec.describe Legion::Extensions::Agentic::Attention::Telescope::Helpers::ObservatoryEngine do
  subject(:engine) { described_class.new }

  let(:telescope) { engine.create_telescope(lens_type: :refractor) }

  describe '#create_telescope' do
    it 'returns a Telescope instance' do
      expect(telescope).to be_a(Legion::Extensions::Agentic::Attention::Telescope::Helpers::Telescope)
    end

    it 'stores the telescope' do
      id = telescope.id
      expect(engine.all_telescopes.map(&:id)).to include(id)
    end

    it 'raises when observatory is full' do
      stub_const('Legion::Extensions::Agentic::Attention::Telescope::Helpers::Constants::MAX_TELESCOPES', 1)
      engine.create_telescope(lens_type: :radio)
      expect { engine.create_telescope(lens_type: :adaptive) }
        .to raise_error(ArgumentError, /observatory full/)
    end

    it 'creates with custom aperture and magnification' do
      t = engine.create_telescope(lens_type: :reflector, aperture: 0.9, magnification: 20.0)
      expect(t.aperture).to eq(0.9)
      expect(t.magnification).to eq(20.0)
    end
  end

  describe '#zoom_in' do
    it 'increases telescope magnification' do
      old = telescope.magnification
      engine.zoom_in(telescope_id: telescope.id, factor: 3.0)
      expect(telescope.magnification).to be > old
    end

    it 'raises for unknown telescope' do
      expect { engine.zoom_in(telescope_id: 'nope', factor: 2.0) }
        .to raise_error(ArgumentError, /telescope not found/)
    end
  end

  describe '#zoom_out' do
    it 'decreases magnification after zoom_in' do
      engine.zoom_in(telescope_id: telescope.id, factor: 10.0)
      old = telescope.magnification
      engine.zoom_out(telescope_id: telescope.id, factor: 2.0)
      expect(telescope.magnification).to be < old
    end

    it 'raises for unknown telescope' do
      expect { engine.zoom_out(telescope_id: 'nope', factor: 2.0) }
        .to raise_error(ArgumentError, /telescope not found/)
    end
  end

  describe '#focus_telescope' do
    it 'sets focal_distance on the telescope' do
      engine.focus_telescope(telescope_id: telescope.id, target_distance: 0.6)
      expect(telescope.focal_distance).to eq(0.6)
    end

    it 'raises for unknown telescope' do
      expect { engine.focus_telescope(telescope_id: 'x', target_distance: 0.5) }
        .to raise_error(ArgumentError, /telescope not found/)
    end
  end

  describe '#observe' do
    it 'returns an Observation' do
      obs = engine.observe(telescope_id: telescope.id, target: 'Mars', distance: 0.4)
      expect(obs).to be_a(Legion::Extensions::Agentic::Attention::Telescope::Helpers::Observation)
    end

    it 'stores the observation' do
      engine.observe(telescope_id: telescope.id, target: 'Venus', distance: 0.3)
      expect(engine.all_observations.size).to eq(1)
    end

    it 'records target and distance' do
      obs = engine.observe(telescope_id: telescope.id, target: 'Jupiter', distance: 0.7)
      expect(obs.target).to eq('Jupiter')
      expect(obs.distance).to eq(0.7)
    end

    it 'raises for unknown telescope' do
      expect { engine.observe(telescope_id: 'nope', target: 'x', distance: 0.5) }
        .to raise_error(ArgumentError, /telescope not found/)
    end

    it 'raises when observation log is full' do
      stub_const('Legion::Extensions::Agentic::Attention::Telescope::Helpers::Constants::MAX_OBSERVATIONS', 1)
      engine.observe(telescope_id: telescope.id, target: 'a', distance: 0.1)
      expect { engine.observe(telescope_id: telescope.id, target: 'b', distance: 0.2) }
        .to raise_error(ArgumentError, /observation log full/)
    end
  end

  describe '#survey_mode!' do
    it 'resets telescope to wide-field (magnification == 1.0)' do
      engine.zoom_in(telescope_id: telescope.id, factor: 20.0)
      engine.survey_mode!(telescope_id: telescope.id)
      expect(telescope.magnification).to eq(1.0)
    end

    it 'raises for unknown telescope' do
      expect { engine.survey_mode!(telescope_id: 'x') }
        .to raise_error(ArgumentError, /telescope not found/)
    end
  end

  describe '#deep_focus!' do
    it 'zooms telescope to MAX_MAGNIFICATION' do
      engine.deep_focus!(telescope_id: telescope.id)
      expect(telescope.magnification).to eq(100.0)
    end

    it 'sets deep_field? to true' do
      engine.deep_focus!(telescope_id: telescope.id)
      expect(telescope.deep_field?).to be true
    end

    it 'raises for unknown telescope' do
      expect { engine.deep_focus!(telescope_id: 'x') }
        .to raise_error(ArgumentError, /telescope not found/)
    end
  end

  describe '#all_telescopes' do
    it 'returns all created telescopes' do
      engine.create_telescope(lens_type: :radio)
      engine.create_telescope(lens_type: :adaptive)
      expect(engine.all_telescopes.size).to eq(2)
    end
  end

  describe '#all_observations' do
    it 'returns a copy of all observations' do
      engine.observe(telescope_id: telescope.id, target: 'a', distance: 0.1)
      engine.observe(telescope_id: telescope.id, target: 'b', distance: 0.2)
      expect(engine.all_observations.size).to eq(2)
    end
  end

  describe '#significant_observations' do
    it 'returns only significant observations' do
      # significant: high magnification + low distance
      engine.zoom_in(telescope_id: telescope.id, factor: 100.0)
      engine.observe(telescope_id: telescope.id, target: 'near', distance: 0.05)
      # faint: low magnification + far distance
      t2 = engine.create_telescope(lens_type: :radio, magnification: 1.0)
      engine.observe(telescope_id: t2.id, target: 'far', distance: 0.99)
      sig = engine.significant_observations
      expect(sig.all?(&:significant?)).to be true
    end
  end

  describe '#observatory_report' do
    it 'returns a hash with all expected keys' do
      telescope
      engine.observe(telescope_id: telescope.id, target: 'x', distance: 0.5)
      report = engine.observatory_report
      %i[total_telescopes total_observations significant_count faint_count
         avg_detail deepest_observation widest_telescope].each do |k|
        expect(report).to have_key(k)
      end
    end

    it 'counts telescopes and observations correctly' do
      telescope
      engine.observe(telescope_id: telescope.id, target: 'a', distance: 0.3)
      engine.observe(telescope_id: telescope.id, target: 'b', distance: 0.6)
      report = engine.observatory_report
      expect(report[:total_telescopes]).to eq(1)
      expect(report[:total_observations]).to eq(2)
    end

    it 'returns nil deepest_observation when no observations exist' do
      telescope
      report = engine.observatory_report
      expect(report[:deepest_observation]).to be_nil
    end

    it 'returns nil widest_telescope when no telescopes exist' do
      report = engine.observatory_report
      expect(report[:widest_telescope]).to be_nil
    end

    it 'reports avg_detail as 0.0 when no observations' do
      telescope
      report = engine.observatory_report
      expect(report[:avg_detail]).to eq(0.0)
    end
  end
end
