describe user('travis') do
  it { should exist }
  it { should have_uid 1000 }
  it { should have_home_directory '/home/travis' }
  it { should have_login_shell '/bin/bash' }
end
