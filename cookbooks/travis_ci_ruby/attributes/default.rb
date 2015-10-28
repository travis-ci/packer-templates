override['rvm']['rubies'] = [
  { name:  '1.9.3', arguments: '--binary --fuzzy' },
  { name:  '1.8.7', arguments: '--binary --fuzzy' },
  # { name:  'jruby-1.7.19-d18', arguments: '--18', check_for: 'jruby-d18' },
  # { name:  'jruby-1.7.19-d19', arguments: '--19', check_for: 'jruby-d19' },
  # { name:  'jruby-9.0.0.0.pre1' },
  { name:  'ree', arguments: '--binary --fuzzy' },
  { name:  '1.9.2' },
  { name:  '2.0.0', arguments: '--binary --fuzzy' },
  { name:  '2.1.2', arguments: '--binary --fuzzy' },
  { name:  '2.1.3', arguments: '--binary --fuzzy' },
  { name:  '2.1.4', arguments: '--binary --fuzzy' },
  { name:  '2.1.5', arguments: '--binary --fuzzy' },
  { name:  '2.2.0', arguments: '--binary --fuzzy' }
]
override['rvm']['gems'] = %w(
  bundler
  rake
)
override['rvm']['aliases'] = {
  # 'jruby-d18' => 'jruby-1.7.19-d18',
  # 'jruby-d19' => 'jruby-1.7.19-d19',
  # 'jruby-18mode' => 'jruby-d18',
  # 'jruby-19mode' => 'jruby-d19',
  # 'jruby' => 'jruby-19mode',
  '2.0' => 'ruby-2.0.0',
  '2.1' => 'ruby-2.1.5',
  '2.2' => 'ruby-2.2.0'
}
override['java']['alternate_versions'] = %w(
  openjdk6
  openjdk7
  oraclejdk8
)
