override['gimme']['versions'] = %w(
  1.0.3
  1.1.2
  1.2.2
  1.3.3
  1.4.1
)
override['gimme']['default_version'] = '1.4.1'
override['travis_packer_templates']['job_board']['codename'] = 'go'
override['travis_packer_templates']['job_board']['languages'] = %w(go)
