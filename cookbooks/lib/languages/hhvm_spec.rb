# frozen_string_literal: true

describe command('sudo apt-cache search hhvm'), sudo: true do
  its(:stdout) { should_not be_empty }
end
