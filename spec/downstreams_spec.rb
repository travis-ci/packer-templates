require 'downstreams'

describe Downstreams do
  subject { described_class.new }

  let(:api_token) { 'flubber' }
  let(:git_name_status) { {} }

  before :each do
    allow(subject).to receive(:travis_api_token).and_return(api_token)
    allow(subject).to receive(:commit).and_return('fafafaf')
    allow(subject).to receive(:last_commit_name_status).and_return(git_name_status)
  end

  describe 'templates' do
    let :git_name_status do
      {
        'horrible-idea.yml' => 'D',
        'rotten-kid-on-the-corner.txt' => 'M',
        'deep/inside/ur/code/.kitchen.yml' => 'M',
        'birthday-cake.yml' => 'A',
        'bouncy-castle.yml' => 'M'
      }
    end

    it 'excludes deleted files' do
      expect(subject.send(:templates)).to_not include(/horrible-idea/)
    end

    it 'excludes non-yml files' do
      expect(subject.send(:templates)).to_not include(/rotten-kid-on-the-corner/)
    end

    it 'excludes yml files in directories' do
      expect(subject.send(:templates)).to_not include(%r{deep/inside/ur/code/\.kitchen\.yml})
    end

    it 'includes modified yml files' do
      expect(subject.send(:templates)).to include('bouncy-castle')
    end

    it 'includes added yml files' do
      expect(subject.send(:templates)).to include('birthday-cake')
    end

    it 'returns basenames in an array' do
      expect(subject.send(:templates)).to eq(%w(birthday-cake bouncy-castle))
    end
  end

  context 'with stubbed templates and builders' do
    before :each do
      allow(subject).to receive(:builders).and_return(%w(fribble schnozzle))
      allow(subject).to receive(:templates).and_return(%w(wooker dippity))
    end

    it { respond_to(:trigger!) }
    it { respond_to(:trigger) }

    describe 'requests' do
      let(:requests) { subject.build_requests }

      it 'creates a request for each template' do
        expect(requests.size).to eq(2)
      end

      it 'is has a body' do
        requests.each do |request|
          expect(request.body).to_not be_empty
        end
      end

      it 'is json' do
        requests.each do |request|
          expect(request['Content-Type']).to eq('application/json')
        end
      end

      it 'specifies API version 3' do
        requests.each do |request|
          expect(request['Travis-API-Version']).to eq('3')
        end
      end

      it 'includes authorization' do
        requests.each do |request|
          expect(request['Authorization']).to eq('token flubber')
        end
      end
    end

    describe 'body' do
      let(:body) { subject.send(:body, 'flurb') }

      it 'has a message with commit' do
        expect(body[:message]).to match(/origin-commit=fafafaf/)
      end

      it 'specifies a branch' do
        expect(body[:branch]).to eq('flurb')
      end

      it 'stubs in some config bits' do
        expect(body[:config]).to include(
          language: 'generic',
          dist: 'trusty',
          group: 'edge',
          sudo: true
        )
      end

      it 'contains an env matrix with each builder and template' do
        expect(body[:config][:env][:matrix])
          .to eq(%w(BUILDER=fribble BUILDER=schnozzle))
      end

      it 'contains an install step that clones packer-templates' do
        expect(body[:config][:install]).to include(
          /git clone.*packer-templates\.git/
        )
        expect(body[:config][:install]).to include(
          /git checkout -qf fafafaf/
        )
      end

      it 'contains an install step that runs bin/packer-build-install' do
        expect(body[:config][:install]).to include(
          %r{\./packer-templates/bin/packer-build-install}
        )
      end

      it 'contains a script step that runs bin/packer-build-script' do
        expect(body[:config][:script]).to eq(
          './packer-templates/bin/packer-build-script flurb'
        )
      end
    end
  end
end
