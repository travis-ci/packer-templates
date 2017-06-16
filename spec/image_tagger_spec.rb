# frozen_string_literal: true

require 'image_tagger'
require 'env'

describe ImageTagger do
  let(:env) { Env.new }

  subject do
    described_class.new(env: env)
  end

  it 'merges env TAGS when making image tags' do
    env['TAGS'] = 'razza:frazza,flim:flam,os:bonk'
    expect(subject.send(:tags)).to include(
      razza: 'frazza', flim: 'flam', os: 'bonk'
    )
  end

  describe 'determining TRAVIS_COOKBOOKS_EDGE_BRANCH' do
    context 'without TRAVIS_COOKBOOKS_EDGE_BRANCH value present' do
      before do
        env['TRAVIS_COOKBOOKS_EDGE_BRANCH'] = ''
      end

      it 'falls back to "master"' do
        expect(subject.send(:travis_cookbooks_edge_branch)).to eq('master')
      end
    end

    context 'with TRAVIS_COOKBOOKS_EDGE_BRANCH value present' do
      before do
        env['TRAVIS_COOKBOOKS_EDGE_BRANCH'] = 'meister'
      end

      it 'uses the value' do
        expect(subject.send(:travis_cookbooks_edge_branch)).to eq('meister')
      end
    end
  end

  describe 'determining TRAVIS_COOKBOOKS_BRANCH' do
    context 'without TRAVIS_COOKBOOKS_BRANCH value present' do
      before do
        env['TRAVIS_COOKBOOKS_BRANCH'] = ''
        env['TRAVIS_COOKBOOKS_EDGE_BRANCH'] = 'floof'
      end

      it 'falls back to TRAVIS_COOKBOOKS_EDGE_BRANCH' do
        expect(subject.send(:travis_cookbooks_branch)).to eq('floof')
      end
    end

    context 'with TRAVIS_COOKBOOKS_BRANCH value present' do
      before do
        env['TRAVIS_COOKBOOKS_BRANCH'] = 'bloof'
        env['TRAVIS_COOKBOOKS_EDGE_BRANCH'] = 'floof'
      end

      it 'uses TRAVIS_COOKBOOKS_BRANCH' do
        expect(subject.send(:travis_cookbooks_branch)).to eq('bloof')
      end
    end

    context 'without TRAVIS_COOKBOOKS_BRANCH ' \
            'or TRAVIS_COOKBOOKS_EDGE_BRANCH' do
      before do
        env['TRAVIS_COOKBOOKS_BRANCH'] = ''
        env['TRAVIS_COOKBOOKS_EDGE_BRANCH'] = ''
      end

      it 'uses master' do
        expect(subject.send(:travis_cookbooks_branch)).to eq('master')
      end
    end
  end
end
