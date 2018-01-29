# frozen_string_literal: true

require 'travis_packer_templates'
require 'support'
require 'chef'

include Support

describe TravisPackerTemplates do
  subject { described_class.new(node) }

  let :node do
    Chef::Node.new.tap do |n|
      n.override['lsb']['codename'] = 'floof'
      n.override['platform'] = 'imaginary'
      n.override['travis_packer_templates'] = attrs
    end
  end

  let(:attrs) { travis_packer_templates_attrs }
  let(:now) { INITTIME }

  before do
    subject.instance_variable_set(:@default_owner, Process.uid)
    subject.instance_variable_set(:@default_group, Process.gid)
    subject.instance_variable_set(:@init_time, now)
  end

  context 'with file IO stubbed out' do
    before do
      allow(File).to receive(:exist?).and_return(false)
      allow(Dir).to receive(:glob).and_yield('SOME_FILE')
      allow(File).to receive(:read).and_return("some-value\n")
    end

    it 'has a node' do
      expect(subject.node).to_not be_nil
    end

    it 'has an init time' do
      expect(subject.init_time).to_not be_nil
    end

    context 'when initializing' do
      it 'imports packer env vars' do
        expect(subject).to receive(:import_packer_env_vars)
        subject.init!(now)
      end

      it 'assigns the travis_system_info.cookbooks_sha attribute' do
        expect(subject).to receive(:assign_travis_system_info_cookbooks_sha)
          .with('fafafaf')
        subject.init!(now)
      end
    end

    context 'when writing /.node-attributes.yml' do
      it 'writes all node attributes to /.node-attributes.yml' do
        expect(subject).to receive(:write_yml).with(
          'some-file.yml',
          node.attributes.to_hash.merge(
            '__timestamp' => subject.init_time.to_s
          )
        )
        subject.write_node_attributes_yml
      end
    end

    context 'when writing /.job-board-register.yml' do
      it 'writes job board attributes to /.job-board-register.yml' do
        expect(subject).to receive(:write_yml).with(
          'another-file.yml',
          job_board_attrs(now: now)
        )
        subject.write_job_board_register_yml
      end
    end
  end

  context 'with real file IO', integration: true do
    let :tmpdir do
      Dir.mktmpdir(%w[packer-templates- -rspec])
    end

    let :packer_env_dir do
      File.join(tmpdir, 'env')
    end

    let :packages_file do
      File.join(tmpdir, 'packages.txt')
    end

    let :node_attributes_yml do
      File.join(tmpdir, 'node-attributes.yml')
    end

    let :job_board_register_yml do
      File.join(tmpdir, 'job-board-register.yml')
    end

    let :attrs do
      travis_packer_templates_attrs.merge(
        'packages_file' => packages_file,
        'packer_env_dir' => packer_env_dir,
        'node_attributes_yml' => node_attributes_yml,
        'job_board_register_yml' => job_board_register_yml
      )
    end

    before do
      File.write(packages_file, <<-EOF.gsub(/^\s+> ?/, ''))
        > flim
        > flam
        > flopper
        > doodle
        > # nopers
      EOF
      FileUtils.mkdir_p(packer_env_dir)
      File.write(
        File.join(packer_env_dir, 'SOMETHIN'),
        "some-value\n"
      )
    end

    context 'when initializing' do
      it 'imports packer env vars' do
        subject.init!(now)
        expect(node['travis_packer_templates']['env']['SOMETHIN'])
          .to eq('some-value')
      end

      it 'assigns the travis_system_info.cookbooks_sha attribute' do
        subject.init!(now)
        expect(node['travis_system_info']['cookbooks_sha']).to eq('fafafaf')
      end

      it 'assigns packages from packages file' do
        subject.init!(now)
        expect(node['travis_packer_templates']['packages'])
          .to eq(%w[flim flam flopper doodle])
      end
    end

    context 'when writing /.node-attributes.yml' do
      it 'has the expected structure' do
        subject.write_node_attributes_yml
        loaded = YAML.load_file(node_attributes_yml)
        expect(loaded).to include(
          '__timestamp' => subject.init_time.to_s
        )
      end
    end

    context 'when writing /.job-board-register.yml' do
      it 'has the expected structure' do
        subject.write_job_board_register_yml
        loaded = YAML.load_file(job_board_register_yml)
        expect(loaded).to eq(job_board_attrs(now: now))
      end
    end
  end
end
