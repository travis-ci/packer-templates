require 'downstreams'

describe Downstreams::Trigger do
  subject { described_class.new }

  let(:api_token) { 'flubber' }
  let(:git_name_status) { {} }
  let(:here) { File.expand_path('../../../', __FILE__) }
  let(:argv) do
    %W(
      --quiet
      --cookbook-path=#{here}/cookbooks
      --packer-templates-path=#{here}
      --git-working-copy=#{here}
      --repo-slug=serious-business/verybigapplication
      --travis-api-url=https://bogus.example.com:9999
      --travis-api-token=SOVERYSECRET
      --commit=fafafaf
      --branch=twig
      --builders=bob,wendy,pickles
    )
  end
  let(:fake_http) { double('fake_http') }
  let(:fake_response) do
    double('fake_response', code: '201')
  end

  before :each do
    allow(subject.send(:options))
      .to receive(:travis_api_token).and_return(api_token)
    allow(subject.send(:options))
      .to receive(:commit).and_return('fafafaf')
    allow(subject).to receive(:last_commit_name_status)
      .and_return(git_name_status)
    allow(subject).to receive(:build_http).and_return(fake_http)
    allow(fake_http).to receive(:request).and_return(fake_response)
  end

  context 'with stubbed templates and builders' do
    before :each do
      allow(subject.send(:options)).to receive(:builders)
        .and_return(%w(fribble schnozzle))
      allow(subject).to receive(:templates).and_return(%w(wooker dippity))
    end

    it 'may be run via .run!' do
      expect(described_class.run!(argv: argv)).to eq(0)
    end

    it 'may be run via #run' do
      expect(subject.run(argv: argv)).to eq(0)
    end

    describe 'requests' do
      let(:requests) { subject.build_requests }

      it 'creates a request for each template' do
        expect(requests.size).to eq(2)
      end

      it 'is has a body' do
        requests.each do |_, request|
          expect(request.body).to_not be_empty
        end
      end

      it 'is json' do
        requests.each do |_, request|
          expect(request['Content-Type']).to eq('application/json')
        end
      end

      it 'specifies API version 3' do
        requests.each do |_, request|
          expect(request['Travis-API-Version']).to eq('3')
        end
      end

      it 'includes authorization' do
        requests.each do |_, request|
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
