# frozen_string_literal: true

# Define log color codes
RED = "\e[31m"
GREEN = "\e[32m"
YELLOW = "\e[33m"
BLUE = "\e[34m"
MAGENTA = "\e[35m"
CYAN = "\e[36m"
RESET = "\e[0m"
PREFIX = "[PYENV-SETUP]"

Chef::Log.info("#{CYAN}#{PREFIX} 🚀 Starting pyenv installation process#{RESET}")

pyenv_installer_path = ::File.join(
  Chef::Config[:file_cache_path], 'pyenv-installer'
)

Chef::Log.info("#{BLUE}#{PREFIX} 📥 Downloading pyenv installer to #{pyenv_installer_path}#{RESET}")
remote_file pyenv_installer_path do
  source node['travis_python']['pyenv_install_url']
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0o755
  notifies :run, 'ruby_block[log_pyenv_download]', :immediately
end

ruby_block 'log_pyenv_download' do
  block do
    Chef::Log.info("#{GREEN}#{PREFIX} ✅ Pyenv installer downloaded successfully to #{pyenv_installer_path}#{RESET}")
  end
  action :nothing
end

Chef::Log.info("#{BLUE}#{PREFIX} 🔧 Running pyenv installer script#{RESET}")
bash 'install_pyenv' do
  code pyenv_installer_path.to_s
  user node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  environment('HOME' => node['travis_build_environment']['home'])
  retries 2
  retry_delay 30
  notifies :run, 'ruby_block[log_pyenv_install_result]', :immediately
end

ruby_block 'log_pyenv_install_result' do
  block do
    pyenv_path = "#{node['travis_build_environment']['home']}/.pyenv"
    if ::File.directory?(pyenv_path)
      Chef::Log.info("#{GREEN}#{PREFIX} ✅ Pyenv successfully installed to #{pyenv_path}#{RESET}")
    else
      Chef::Log.error("#{RED}#{PREFIX} ❌ Failed to install pyenv to #{pyenv_path}#{RESET}")
    end
  end
  action :nothing
end

Chef::Log.info("#{BLUE}#{PREFIX} 🔄 Creating symlink to pyenv at /opt/pyenv#{RESET}")
link '/opt/pyenv' do
  to "#{node['travis_build_environment']['home']}/.pyenv"
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0o755
  notifies :run, 'ruby_block[log_symlink_result]', :immediately
end

ruby_block 'log_symlink_result' do
  block do
    if ::File.symlink?('/opt/pyenv')
      Chef::Log.info("#{GREEN}#{PREFIX} ✅ Symlink to pyenv created successfully#{RESET}")
    else
      Chef::Log.error("#{RED}#{PREFIX} ❌ Failed to create symlink to pyenv#{RESET}")
    end
  end
  action :nothing
end

bash_profile = ::File.join(
  node['travis_build_environment']['home'],
  '.bash_profile'
)

Chef::Log.info("#{BLUE}#{PREFIX} ⚙️ Adding pyenv to PATH in #{bash_profile}#{RESET}")
bash 'export_path_to_pyenv' do
  code "echo 'export PATH=#{node['travis_build_environment']['home']}/.pyenv/bin:$PATH' >> #{bash_profile}"
  user node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  notifies :run, 'ruby_block[log_path_export]', :immediately
end

ruby_block 'log_path_export' do
  block do
    Chef::Log.info("#{GREEN}#{PREFIX} ✅ Pyenv PATH export added to bash profile#{RESET}")
  end
  action :nothing
end

Chef::Log.info("#{BLUE}#{PREFIX} ⚙️ Adding pyenv init to bash profile#{RESET}")
bash 'add_pyenv_init_to_bash_profile' do
  code "echo 'eval \"$(pyenv init -)\"' >> #{bash_profile}"
  user node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  notifies :run, 'ruby_block[log_pyenv_init]', :immediately
end

ruby_block 'log_pyenv_init' do
  block do
    Chef::Log.info("#{GREEN}#{PREFIX} ✅ Pyenv init added to bash profile#{RESET}")
  end
  action :nothing
end

Chef::Log.info("#{BLUE}#{PREFIX} ⚙️ Adding virtualenv init to bash profile#{RESET}")
bash 'add_virtualenv_init_to_bash_profile' do
  code "echo 'eval \"$(pyenv virtualenv-init -)\"' >> #{bash_profile}"
  user node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  notifies :run, 'ruby_block[log_virtualenv_init]', :immediately
end

ruby_block 'log_virtualenv_init' do
  block do
    Chef::Log.info("#{GREEN}#{PREFIX} ✅ Pyenv virtualenv-init added to bash profile#{RESET}")
  end
  action :nothing
end

pyenv_versions = %w[
  3.7.6
  3.8.1
  3.9.16
  3.10.9
]

Chef::Log.info("#{MAGENTA}#{PREFIX} 📋 Installing Python versions: #{pyenv_versions.join(', ')}#{RESET}")
pyenv_versions.each do |version|
  Chef::Log.info("#{YELLOW}#{PREFIX} ⏳ Starting installation of Python #{version}#{RESET}")
  bash "pyenv_install_#{version}" do
    code <<-EOH
      source #{bash_profile}
      echo "#{YELLOW}#{PREFIX} ⏳ Starting installation of Python #{version}#{RESET}"
      pyenv install #{version}
      if pyenv versions | grep #{version}; then
        echo "#{GREEN}#{PREFIX} ✅ Python #{version} installed successfully#{RESET}"
      else
        echo "#{RED}#{PREFIX} ❌ Failed to install Python #{version}#{RESET}"
        exit 1
      fi
    EOH
    user node['travis_build_environment']['user']
    group node['travis_build_environment']['group']
    environment(
      'HOME' => node['travis_build_environment']['home'],
      'PATH' => ENV.fetch('PATH', nil)
    )
    notifies :run, "ruby_block[log_python_#{version}_install]", :immediately
  end

  ruby_block "log_python_#{version}_install" do
    block do
      Chef::Log.info("#{GREEN}#{PREFIX} ✅ Completed installation attempt of Python #{version}#{RESET}")
    end
    action :nothing
  end
end

Chef::Log.info("#{BLUE}#{PREFIX} 🔄 Setting global Python version to 3.8.1#{RESET}")
bash 'pyenv_global_set_to_3.8.1' do
  code <<-EOH
    source #{bash_profile}
    pyenv global 3.8.1
    echo "#{BLUE}#{PREFIX} 🔍 Current Python version: $(python --version)#{RESET}"
    if [[ "$(python --version 2>&1)" == *"3.8.1"* ]]; then
      echo "#{GREEN}#{PREFIX} ✅ Successfully set global Python version to 3.8.1#{RESET}"
    else
      echo "#{RED}#{PREFIX} ❌ Failed to set global Python version to 3.8.1#{RESET}"
      exit 1
    fi
  EOH
  user node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  environment(
    'HOME' => node['travis_build_environment']['home'],
    'PATH' => ENV.fetch('PATH', nil)
  )
  notifies :run, 'ruby_block[log_global_python]', :immediately
end

ruby_block 'log_global_python' do
  block do
    Chef::Log.info("#{GREEN}#{PREFIX} ✅ Global Python version set to 3.8.1#{RESET}")
  end
  action :nothing
end

Chef::Log.info("#{BLUE}#{PREFIX} 📦 Installing virtualenv#{RESET}")
bash 'pip_install_virtualenv' do
  code <<-EOH
    source #{bash_profile}
    echo "#{BLUE}#{PREFIX} 📦 Installing virtualenv 15.1.0#{RESET}"
    pip install virtualenv==15.1.0
    if pip list | grep virtualenv; then
      echo "#{GREEN}#{PREFIX} ✅ Virtualenv 15.1.0 installed successfully#{RESET}"
    else
      echo "#{RED}#{PREFIX} ❌ Failed to install virtualenv#{RESET}"
      exit 1
    fi
  EOH
  user node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  environment(
    'HOME' => node['travis_build_environment']['home'],
    'PATH' => ENV.fetch('PATH', nil)
  )
  notifies :run, 'ruby_block[log_virtualenv_install]', :immediately
end

ruby_block 'log_virtualenv_install' do
  block do
    Chef::Log.info("#{GREEN}#{PREFIX} ✅ Virtualenv installation completed#{RESET}")
  end
  action :nothing
end

Chef::Log.info("#{CYAN}#{PREFIX} 🏁 Pyenv and Python installation process completed#{RESET}")

ruby_block 'verify_full_installation' do
  block do
    Chef::Log.info("#{MAGENTA}#{PREFIX} 🔍 Verifying full installation#{RESET}")
    pyenv_installed = ::File.directory?("#{node['travis_build_environment']['home']}/.pyenv")
    symlink_created = ::File.symlink?('/opt/pyenv')
    
    Chef::Log.info("#{pyenv_installed ? GREEN : RED}#{PREFIX} 🔹 Pyenv installed: #{pyenv_installed ? '✅' : '❌'}#{RESET}")
    Chef::Log.info("#{symlink_created ? GREEN : RED}#{PREFIX} 🔹 Symlink created: #{symlink_created ? '✅' : '❌'}#{RESET}")
    
    if pyenv_installed && symlink_created
      Chef::Log.info("#{GREEN}#{PREFIX} 🎉 Installation verification passed#{RESET}")
    else
      Chef::Log.error("#{RED}#{PREFIX} ⛔ Installation verification failed#{RESET}")
    end
  end
  action :run
end

# Final installation report
ruby_block 'installation_summary' do
  block do
    puts "\n"
    puts "#{MAGENTA}#{PREFIX} =============================================#{RESET}"
    puts "#{MAGENTA}#{PREFIX} 🎯 PYENV INSTALLATION SUMMARY#{RESET}"
    puts "#{MAGENTA}#{PREFIX} =============================================#{RESET}"
    puts "#{BLUE}#{PREFIX} 📌 Pyenv location: #{node['travis_build_environment']['home']}/.pyenv#{RESET}"
    puts "#{BLUE}#{PREFIX} 📌 Symlink: /opt/pyenv#{RESET}"
    puts "#{BLUE}#{PREFIX} 📌 Python versions installed: #{pyenv_versions.join(', ')}#{RESET}"
    puts "#{BLUE}#{PREFIX} 📌 Global Python version: 3.8.1#{RESET}"
    puts "#{BLUE}#{PREFIX} 📌 Bash profile: #{bash_profile}#{RESET}"
    puts "#{MAGENTA}#{PREFIX} =============================================#{RESET}"
    puts "\n"
  end
  action :run
end
