#
# Cookbook:: python
# Recipe:: default
#
#

python_version = '3.9.9'
tarball        = "Python-#{python_version}.tgz"
src_dir        = '/usr/local/src'
download_url   = "https://www.python.org/ftp/python/#{python_version}/#{tarball}"

directory src_dir do
  recursive true
  action :create
end

remote_file "#{src_dir}/#{tarball}" do
  source download_url
  mode '0644'
  action :create_if_missing
end

bash 'build_python' do
  cwd src_dir
  code <<-EOH
    tar -xzf #{tarball}
    cd Python-#{python_version}
    ./configure --prefix=/usr/local
    make -j$(sysctl -n hw.ncpu)
    make altinstall
  EOH
  
  not_if "/usr/local/bin/python3.9 --version | grep '#{python_version}'"
end
