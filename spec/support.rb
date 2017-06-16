# frozen_string_literal: true

require 'simplecov'

module Support
  INITTIME = Time.now.utc

  def travis_packer_templates_attrs
    {
      'env' => {
        'TRAVIS_COOKBOOKS_SHA' => 'fafafaf'
      },
      'packages_file' => 'some/file',
      'node_attributes_yml' => 'some-file.yml',
      'job_board_register_yml' => 'another-file.yml',
      'job_board' => {
        'languages' => %w[ruby python french],
        'features' => %w[mysql mongodb lulz]
      }
    }
  end

  def job_board_attrs(now: INITTIME)
    {
      'languages' => %w[ruby python french],
      'features' => %w[mysql mongodb lulz],
      'tags' => {
        'dist' => 'floof',
        'os' => 'imaginary',
        'packer_chef_time' => now.strftime('%Y%m%dT%H%M%SZ'),
        'language_ruby' => true,
        'language_python' => true,
        'language_french' => true,
        'feature_mysql' => true,
        'feature_mongodb' => true,
        'feature_lulz' => true
      },
      'tags_string' => %W[
        dist:floof
        feature_lulz:true
        feature_mongodb:true
        feature_mysql:true
        language_french:true
        language_python:true
        language_ruby:true
        os:imaginary
        packer_chef_time:#{now.strftime('%Y%m%dT%H%M%SZ')}
      ].join(',')
    }
  end
end
