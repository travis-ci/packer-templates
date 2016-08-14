describe user('travis') do
  it { should exist }
  it { should have_home_directory('/home/travis') }
  it 'has an unexpected password' do
    salt = subject.encrypted_password.split('$').fetch(2)
    re_encrypted = `mkpasswd -m sha-512 travis #{salt}`.strip
    expect(subject.encrypted_password).to_not eq(re_encrypted)
  end
end
