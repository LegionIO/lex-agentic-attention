# frozen_string_literal: true

RSpec.describe Legion::Extensions::Agentic::Attention::Telescope::Client do
  subject(:client) { described_class.new }

  let(:engine) { Legion::Extensions::Agentic::Attention::Telescope::Helpers::ObservatoryEngine.new }

  it 'includes runner methods' do
    expect(client).to respond_to(:create_telescope)
    expect(client).to respond_to(:zoom_in)
    expect(client).to respond_to(:zoom_out)
    expect(client).to respond_to(:observe)
    expect(client).to respond_to(:focus)
    expect(client).to respond_to(:survey_mode)
    expect(client).to respond_to(:deep_focus)
    expect(client).to respond_to(:list_observations)
    expect(client).to respond_to(:observatory_status)
  end

  it 'delegates create_telescope to runner' do
    result = client.create_telescope(lens_type: :refractor, engine: engine)
    expect(result[:success]).to be true
  end

  it 'delegates observatory_status to runner' do
    result = client.observatory_status(engine: engine)
    expect(result[:success]).to be true
    expect(result[:report]).to have_key(:total_telescopes)
  end
end
