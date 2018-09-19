# frozen_string_literal: true

class ImageTagger
  def initialize(env: nil)
    @env = env
  end

  def tags
    tags_defaults.tap do |tags|
      tags[:packer_build_name] = env['PACKER_BUILD_NAME'] if
        env.key?('PACKER_BUILD_NAME')
      tags[:packer_builder_type] = env['PACKER_BUILDER_TYPE'] if
        env.key?('PACKER_BUILDER_TYPE')
      if env.key?('TAGS')
        env['TAGS'].split(',').each do |tag_pair|
          key, value = tag_pair.split(':', 2)
          tags[key.to_sym] = value unless value.to_s.empty?
        end
      end
    end
  end

  def infra
    @infra ||= {
      'googlecompute' => 'gce',
      'docker' => 'docker',
      'vmware' => 'jupiterbrain'
    }.fetch(env['PACKER_BUILDER_TYPE'], 'local')
  end

  private

  def tags_defaults
    {
      os: os,
      :"group_#{group}" => 'true',
      group: group,
      dist: dist,
      packer_templates_branch: env['PACKER_TEMPLATES_BRANCH'],
      packer_templates_sha: env['PACKER_TEMPLATES_SHA'],
      travis_cookbooks_branch: travis_cookbooks_branch,
      travis_cookbooks_sha: env['TRAVIS_COOKBOOKS_SHA']
    }
  end

  def os
    return env['OS'] unless env['OS'].empty?
    return 'osx' if RUBY_PLATFORM =~ /darwin/i
    return 'linux' if RUBY_PLATFORM =~ /linux/i

    'unknown'
  end

  def group
    return 'edge' if
      travis_cookbooks_branch == travis_cookbooks_edge_branch &&
      env['TRAVIS_COOKBOOKS_SHA'] !~ /dirty/ &&
      env['PACKER_TEMPLATES_BRANCH'] == 'master' &&
      env['PACKER_TEMPLATES_SHA'] !~ /dirty/

    'dev'
  end

  def dist
    return env['DIST'] unless env['DIST'].empty?
    return `lsb_release -sc 2>/dev/null`.strip if os == 'linux'
    return `sw_vers -productVersion 2>/dev/null`.strip if os == 'osx'

    'unknown'
  end

  def travis_cookbooks_branch
    value = env['TRAVIS_COOKBOOKS_BRANCH']
    return value unless value.empty?

    travis_cookbooks_edge_branch
  end

  def travis_cookbooks_edge_branch
    value = env['TRAVIS_COOKBOOKS_EDGE_BRANCH']
    return value unless value.empty?

    'master'
  end

  attr_reader :env
end
