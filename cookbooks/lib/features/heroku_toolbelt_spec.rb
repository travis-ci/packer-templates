describe command('heroku version'), dev: true, precise: false do
  its(:stdout) { should match(%r{^heroku-toolbelt\/\d}) }
  its(:stdout) { should match(%r{^heroku-cli\/\d}) }
end
