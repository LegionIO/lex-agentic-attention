# frozen_string_literal: true

RSpec.describe Legion::Extensions::Agentic::Attention::Telescope::Helpers::Telescope do
  subject(:telescope) { described_class.new(lens_type: :refractor) }

  describe '#initialize' do
    it 'generates a uuid id' do
      expect(telescope.id).to match(/\A[0-9a-f-]{36}\z/)
    end

    it 'stores the lens_type as symbol' do
      expect(telescope.lens_type).to eq(:refractor)
    end

    it 'defaults aperture to 0.5' do
      expect(telescope.aperture).to eq(0.5)
    end

    it 'defaults magnification to 1.0' do
      expect(telescope.magnification).to eq(1.0)
    end

    it 'defaults tracking to false' do
      expect(telescope.tracking).to be false
    end

    it 'starts with nil focal_distance' do
      expect(telescope.focal_distance).to be_nil
    end

    it 'sets created_at' do
      expect(telescope.created_at).to be_a(Time)
    end

    it 'accepts custom aperture' do
      t = described_class.new(lens_type: :reflector, aperture: 0.8)
      expect(t.aperture).to eq(0.8)
    end

    it 'clamps aperture to 0.1 minimum' do
      t = described_class.new(lens_type: :radio, aperture: 0.0)
      expect(t.aperture).to eq(0.1)
    end

    it 'clamps aperture to 1.0 maximum' do
      t = described_class.new(lens_type: :adaptive, aperture: 5.0)
      expect(t.aperture).to eq(1.0)
    end

    it 'clamps magnification to BASE_MAGNIFICATION minimum' do
      t = described_class.new(lens_type: :catadioptric, magnification: 0.0)
      expect(t.magnification).to eq(1.0)
    end

    it 'clamps magnification to MAX_MAGNIFICATION maximum' do
      t = described_class.new(lens_type: :reflector, magnification: 999.0)
      expect(t.magnification).to eq(100.0)
    end

    it 'rejects unknown lens types' do
      expect { described_class.new(lens_type: :laser) }
        .to raise_error(ArgumentError, /unknown lens type/)
    end

    it 'accepts tracking: true' do
      t = described_class.new(lens_type: :radio, tracking: true)
      expect(t.tracking).to be true
    end
  end

  describe '#zoom_in!' do
    it 'increases magnification' do
      old = telescope.magnification
      telescope.zoom_in!(2.0)
      expect(telescope.magnification).to be > old
    end

    it 'doubles magnification with factor 2' do
      telescope.zoom_in!(2.0)
      expect(telescope.magnification).to eq(2.0)
    end

    it 'does not exceed MAX_MAGNIFICATION' do
      telescope.zoom_in!(1000.0)
      expect(telescope.magnification).to eq(100.0)
    end

    it 'returns self for chaining' do
      expect(telescope.zoom_in!(2.0)).to eq(telescope)
    end
  end

  describe '#zoom_out!' do
    it 'decreases magnification' do
      telescope.zoom_in!(10.0)
      old = telescope.magnification
      telescope.zoom_out!(2.0)
      expect(telescope.magnification).to be < old
    end

    it 'does not go below BASE_MAGNIFICATION' do
      telescope.zoom_out!(1000.0)
      expect(telescope.magnification).to eq(1.0)
    end

    it 'returns self for chaining' do
      expect(telescope.zoom_out!(2.0)).to eq(telescope)
    end
  end

  describe '#field_of_view' do
    it 'is 1.0 at BASE_MAGNIFICATION with aperture 1.0' do
      t = described_class.new(lens_type: :refractor, aperture: 1.0)
      expect(t.field_of_view).to eq(1.0)
    end

    it 'decreases when magnification increases' do
      wide = telescope.field_of_view
      telescope.zoom_in!(10.0)
      expect(telescope.field_of_view).to be < wide
    end

    it 'is larger with higher aperture at same magnification' do
      t1 = described_class.new(lens_type: :refractor, aperture: 0.3)
      t2 = described_class.new(lens_type: :refractor, aperture: 0.9)
      expect(t2.field_of_view).to be > t1.field_of_view
    end
  end

  describe '#clarity' do
    it 'returns a float between 0 and 1' do
      expect(telescope.clarity).to be_between(0.0, 1.0)
    end

    it 'is higher with larger aperture' do
      t1 = described_class.new(lens_type: :reflector, aperture: 0.2)
      t2 = described_class.new(lens_type: :reflector, aperture: 0.9)
      expect(t2.clarity).to be > t1.clarity
    end
  end

  describe '#focus!' do
    it 'sets focal_distance' do
      telescope.focus!(0.7)
      expect(telescope.focal_distance).to eq(0.7)
    end

    it 'clamps focal_distance to 0..1' do
      telescope.focus!(5.0)
      expect(telescope.focal_distance).to eq(1.0)
    end

    it 'returns self for chaining' do
      expect(telescope.focus!(0.5)).to eq(telescope)
    end
  end

  describe '#enable_tracking! / #disable_tracking!' do
    it 'enables tracking' do
      telescope.enable_tracking!
      expect(telescope.tracking).to be true
    end

    it 'disables tracking' do
      telescope.enable_tracking!
      telescope.disable_tracking!
      expect(telescope.tracking).to be false
    end

    it 'enable_tracking! returns self' do
      expect(telescope.enable_tracking!).to eq(telescope)
    end

    it 'disable_tracking! returns self' do
      expect(telescope.disable_tracking!).to eq(telescope)
    end
  end

  describe '#deep_field?' do
    it 'returns false at low magnification' do
      expect(telescope.deep_field?).to be false
    end

    it 'returns true when magnification >= 50' do
      telescope.zoom_in!(50.0)
      expect(telescope.deep_field?).to be true
    end
  end

  describe '#wide_field?' do
    it 'returns true at base magnification' do
      expect(telescope.wide_field?).to be true
    end

    it 'returns false at high magnification' do
      telescope.zoom_in!(10.0)
      expect(telescope.wide_field?).to be false
    end
  end

  describe '#sharp?' do
    it 'returns true for large aperture telescope' do
      t = described_class.new(lens_type: :adaptive, aperture: 1.0)
      expect(t.sharp?).to be true
    end

    it 'returns false for small aperture telescope' do
      t = described_class.new(lens_type: :radio, aperture: 0.1)
      expect(t.sharp?).to be false
    end
  end

  describe '#blurry?' do
    it 'returns false for normal aperture' do
      expect(telescope.blurry?).to be false
    end

    it 'returns true for very small aperture' do
      t = described_class.new(lens_type: :refractor, aperture: 0.1)
      expect(t.blurry?).to be true
    end
  end

  describe '#clarity_label' do
    it 'returns a symbol' do
      expect(telescope.clarity_label).to be_a(Symbol)
    end

    it 'returns :crystal for a large-aperture telescope' do
      t = described_class.new(lens_type: :adaptive, aperture: 1.0)
      expect(t.clarity_label).to eq(:crystal)
    end
  end

  describe '#to_h' do
    it 'returns a hash with all expected keys' do
      h = telescope.to_h
      %i[id lens_type aperture magnification tracking focal_distance
         field_of_view clarity clarity_label deep_field wide_field
         sharp blurry created_at].each do |key|
        expect(h).to have_key(key)
      end
    end

    it 'reflects current state' do
      telescope.zoom_in!(10.0)
      h = telescope.to_h
      expect(h[:magnification]).to eq(10.0)
    end
  end
end
