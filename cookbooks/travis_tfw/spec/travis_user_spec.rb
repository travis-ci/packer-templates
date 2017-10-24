# frozen_string_literal: true

describe user('travis') do
  it { should exist }
  it { should have_home_directory('/home/travis') }
  it 'has an unexpected password' do
    # get the encrypted password directly, since serverspec doesn't appear to
    # take current uid into account, meaning it doesn't use sudo when it should
    encrypted_password = `sudo getent shadow travis | cut -f 2 -d ':'`.strip
    salt = encrypted_password.split('$').fetch(2)
    re_encrypted = `mkpasswd -m sha-512 travis #{salt}`.strip
    expect(encrypted_password).to_not eq(re_encrypted)
  end
end
