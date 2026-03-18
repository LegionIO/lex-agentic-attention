# frozen_string_literal: true

RSpec.describe Legion::Extensions::Agentic::Attention::RelevanceTheory do
  it 'has a version number' do
    expect(Legion::Extensions::Agentic::Attention::RelevanceTheory::VERSION).not_to be_nil
  end

  it 'has a version that is a string' do
    expect(Legion::Extensions::Agentic::Attention::RelevanceTheory::VERSION).to be_a(String)
  end
end
