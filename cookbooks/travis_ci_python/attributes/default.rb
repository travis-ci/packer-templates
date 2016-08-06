pythons = %w(
  2.6.9
  2.7.12
  3.2.6
  3.3.6
  3.4.4
  3.5.2
  pypy-5.3.1
  pypy3-2.4.0
)
# Reorder pythons so that default python2 and python3 come first
# as this affects the ordering in $PATH.
%w(3 2).each do |pyver|
  pythons.select { |p| p =~ /^#{pyver}/ }.max.tap do |py|
    pythons.unshift(pythons.delete(py))
  end
end

def python_aliases(full_name)
  nodash = full_name.split('-').first
  return [nodash] unless nodash.include?('.')
  [nodash[0, 3]]
end

override['travis_python']['pyenv']['pythons'] = pythons
pythons.each do |full_name|
  override['travis_python']['pyenv']['aliases'][full_name] = \
    python_aliases(full_name)
end

override['travis_packer_templates']['job_board']['codename'] = 'python'
override['travis_packer_templates']['job_board']['features'] = %w(
  basic
  chromium
  firefox
  google-chrome
  memcached
  mongodb
  phantomjs
  postgresql
  rabbitmq
  redis
  sphinxsearch
  sqlite
  xserver
)
override['travis_packer_templates']['job_board']['languages'] = %w(python)
