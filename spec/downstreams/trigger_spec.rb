require 'downstreams'

describe Downstreams::Trigger do
  subject { described_class.new }

  let(:api_token) { 'flubber' }
  let(:git_diff_files) { [] }
  let(:here) { File.expand_path('../../../', __FILE__) }
  let(:fake_detector) { double('fake_detector') }

  let :argv do
    %W(
      --quiet
      --chef-cookbook-path=#{here}/.git::cookbooks
      --packer-templates-path=#{here}/.git::cookbooks
      --target-repo-slug=serious-business/verybigapplication
      --travis-api-url=https://bogus.example.com:9999
      --travis-api-token=SOVERYSECRET
      --commit-range=fafafaf...afafafa
      --branch=twig
      --builders=bob,wendy,pickles
    )
  end

  let :test_http do
    Faraday.new do |faraday|
      faraday.adapter :test, http_stubs
    end
  end

  let :http_stubs do
    Faraday::Adapter::Test::Stubs.new
  end

  before :each do
    allow_any_instance_of(described_class)
      .to receive(:build_http).and_return(test_http)
    allow(subject.send(:options))
      .to receive(:travis_api_token).and_return(api_token)
    allow(subject.send(:options))
      .to receive(:commit_range).and_return(%w(fafafaf afafafa))
    allow_any_instance_of(described_class)
      .to receive(:root_repo_commit_range_diff_files).and_return(git_diff_files)
    http_stubs.post(
      '/repo/serious-business%2Fverybigapplication/requests'
    ) do |_env|
      [201, { 'Content-Type' => 'application/json' }, '{"yey":true}']
    end
    allow(subject.send(:options)).to receive(:builders)
      .and_return(%w(fribble schnozzle))
    allow(subject).to receive(:detectors).and_return([fake_detector])
    allow(fake_detector).to receive(:detect).and_return(%w(wooker dippity))
  end

  it 'may be run via .run!' do
    expect(described_class.run!(argv: argv)).to eq(0)
  end

  it 'may be run via #run' do
    expect(subject.run(argv: argv)).to eq(0)
  end

  describe 'requests' do
    let :requests do
      subject.send(:setup, argv)
      subject.send(:build_requests)
    end

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
        expect(request.headers['Content-Type']).to eq('application/json')
      end
    end

    it 'specifies API version 3' do
      requests.each do |_, request|
        expect(request.headers['Travis-API-Version']).to eq('3')
      end
    end

    it 'includes authorization' do
      requests.each do |_, request|
        expect(request.headers['Authorization']).to eq('token flubber')
      end
    end
  end

  describe 'body' do
    let(:body) { subject.send(:body, 'flurb') }

    it 'has a message with commit' do
      expect(body[:message]).to match(/commit-range=fafafaf\.\.\.afafafa/)
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
        /git checkout -qf afafafa/
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
