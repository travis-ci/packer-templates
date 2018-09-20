# frozen_string_literal: true

require 'rspec/expectations'

module Support
  class JobBoardTags
    def self.load_specs!
      new.load_specs!
    end

    def load_specs!
      %w[language feature].each do |tagset|
        declared_job_board_tagset("#{tagset}s").each do |value|
          spec_name = "#{tagset}s/#{value.tr('-', '_')}_spec"
          begin
            require spec_name
          rescue LoadError => e
            # The path must be checked to ensure the LoadError is not
            # from a broken require within the file being loaded.
            raise e if draconian? || e.path != spec_name

            warn "TODO: missing #{spec_name}"
          end
        end
      end
    end

    private

    def declared_job_board_tagset(tagset)
      YAML.safe_load(File.read(job_board_register_yml)).fetch(tagset)
    end

    def job_board_register_yml
      ENV['TRAVIS_JOB_BOARD_REGISTER_YML'] || '/.job-board-register.yml'
    end

    def draconian?
      ENV['TRAVIS_JOB_BOARD_TAGS_SPECS'] == 'draconian'
    end
  end
end
