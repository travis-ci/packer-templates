# frozen_string_literal: true

create_superusers_script = ::File.join(
  Chef::Config[:file_cache_path],
  'postgresql_create_superusers.sql'
)

if !node['travis_postgresql']['superusers'].to_a.empty? && !::File.exist?(create_superusers_script)
  service 'postgresql' do
    action :start
    ignore_failure true
    timeout 30
  end

  template create_superusers_script do
    source 'create_superusers.sql.erb'
    owner 'postgres'
  end

  Range.new(
    node['travis_postgresql']['port'],
    node['travis_postgresql']['port'] + node['travis_postgresql']['alternate_versions'].length
  ).each do |pg_port|
    execute 'Execute SQL script to create additional superusers' do
      command "psql --port=#{pg_port} --file=#{create_superusers_script}"
      user 'postgres'
    end
  end
end


