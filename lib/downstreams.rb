module Downstreams
  autoload :Trigger, 'downstreams/trigger'
  autoload :ChefDetector, 'downstreams/chef_detector'
  autoload :ChefCookbooks, 'downstreams/chef_cookbooks'
  autoload :ChefPackerTemplates, 'downstreams/chef_packer_templates'
  autoload :ChefFakeRecipeMethods, 'downstreams/chef_fake_recipe_methods'
end
