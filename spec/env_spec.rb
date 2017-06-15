# frozen_string_literal: true

require 'env'

describe Env do
  subject { described_class.new(base: { 'SOMETHING' => 'wow' }) }

  before do
    allow(Dir).to receive(:glob).and_yield('some/path/KEY')
    allow(File).to receive(:file?).with('some/path/KEY')
                                  .and_return(true)
    allow(File).to receive(:read).with('some/path/KEY')
                                 .and_return("exciting-value!\n")
  end

  it 'has an initial state' do
    expect(subject.send(:state)).to_not be_nil
  end

  it 'defines delegators to its state' do
    expect(subject).to respond_to(:[]=)
    expect(subject).to respond_to(:key?)
    expect(subject).to respond_to(:clear)
    expect(subject).to respond_to(:to_hash)
  end

  it 'can load an envdir' do
    subject.load_envdir('some/path')
    expect(subject.key?('KEY')).to eq(true)
    expect(subject['KEY']).to eq('exciting-value!')
  end
end
