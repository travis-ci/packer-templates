describe command('heroku version') do
  its(:stdout) { should match(/^heroku-toolbelt\/\d/) }
  its(:stdout) { should match(/^heroku-cli\/\d/) }
end
