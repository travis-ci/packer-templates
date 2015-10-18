describe 'travis_build_environment packages' do
  Support.base_packages.each do |package_name|
    describe(package(package_name)) { it { should be_installed } }
  end
end
