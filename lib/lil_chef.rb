class LilChef
  def initialize(cookbooks_dir, packer_templates_dir)
    @cookbooks_dir = cookbooks_dir
    @packer_templates_dir = packer_templates_dir
  end

  def dostuff(filenames)
    # * walk the @packer_templates_dir, get list of packer templates
    # * for each packer template, if it contains a chef-solo provisioner,
    #   read the members of the run_list
    # * for each member of the run_list, evaluate/read the relevant
    #   recipe, looking for `include_recipe`.
    # * follow the `include_recipe` bits until (condition??)
    # * if a git commit path is inside a found cookbook, then append
    #   the affected template to a list (which is returned later)
  end
end
