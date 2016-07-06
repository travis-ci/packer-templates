module Downstreams
  autoload :ChefCookbooks, 'downstreams/chef_cookbooks'
  autoload :ChefDependencyFinder, 'downstreams/chef_dependency_finder'
  autoload :ChefDetector, 'downstreams/chef_detector'
  autoload :ChefFakeRecipeMethods, 'downstreams/chef_fake_recipe_methods'
  autoload :ChefPackerTemplate, 'downstreams/chef_packer_template'
  autoload :ChefPackerTemplates, 'downstreams/chef_packer_templates'
  autoload :FileDetector, 'downstreams/file_detector'
  autoload :PackerTemplate, 'downstreams/packer_template'
  autoload :PackerTemplates, 'downstreams/packer_templates'
  autoload :ShellDetector, 'downstreams/shell_detector'
  autoload :Trigger, 'downstreams/trigger'
  autoload :YamlLoader, 'downstreams/yaml_loader'
end
