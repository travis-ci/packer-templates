require 'English'
require 'find'
require 'thread'
require 'yaml'

class LilChef
  class Cookbooks
    def self.load(cookbooks_dir)
      inst = new
      inst.load(cookbooks_dir)
      inst
    end

    def initialize
      @rec = {}
    end

    def load(cookbooks_dir)
      Dir.foreach(cookbooks_dir) do |f|
        if File.exist?(File.join(cookbooks_dir, f, 'metadata.rb'))
          @rec[f] = load_files(File.join(cookbooks_dir, f))
        end
      end
    end

    def files(cookbook)
      @rec[cookbook]
    end

    private

    def load_files(cookbook)
      Find.find(cookbook).select { |f| File.file?(f) }
    end
  end

  class PackerTemplates
    def self.load(cookbook_path, packer_templates_dir)
      inst = new
      inst.load(cookbook_path, packer_templates_dir)
      inst
    end

    def initialize
      @rec = {}
    end

    def each(&block)
      @rec.each(&block)
    end

    def load(cookbook_path, packer_templates_dir)
      packer_templates(packer_templates_dir).each do |filename|
        parsed = YAML.load_file(filename)
        Array(parsed['provisioners']).each do |provisioner|
          next unless provisioner['type'] =~ /chef/
          next if Array(provisioner.fetch('run_list', [])).empty?
          key = File.basename(filename, '.yml')
          @rec[key] = find_cookbooks(provisioner['run_list'], cookbook_path)
        end
      end
    end

    private

    def packer_templates(packer_templates_dir)
      Find.find(packer_templates_dir).map do |f|
        packer_template?(f) ? f : nil
      end.compact.sort
    end

    def packer_template?(filename)
      return false unless File.basename(filename).end_with?('.yml')
      return false if File.basename(filename).start_with?('.')
      parsed = YAML.load_file(filename)
      %w(variables builders provisioners).all? { |k| parsed.include?(k) }
    rescue => e
      $stderr.puts "lil_chef ERROR: #{e}"
      false
    end

    def find_cookbooks(run_list, cookbook_path)
      Array(run_list).map do |cb|
        find_dependency_cookbooks(
          cb.gsub(/^recipe\[/, '').delete(']'),
          cookbook_path
        )
      end.flatten.sort.uniq
    end

    def find_dependency_cookbooks(cookbook_name, cookbook_path)
      deps = [cookbook_name]
      sem = Mutex.new
      cookbook_path.each do |cookbooks_dir|
        recipes_dir = File.join(cookbooks_dir, cookbook_name, 'recipes')
        next unless File.exist?(recipes_dir)
        Dir.glob(File.join(recipes_dir, '*.rb')) do |recipe_rb|
          sem.synchronize do
            begin
              @included_recipes = []
              @node = {
                'travis_ci_standard' => {
                  'standalone' => false
                },
                'travis_packer_templates' => {
                  'env' => {
                    'PACKER_BUILDER_TYPE' => 'lilchef'
                  }
                }
              }
              instance_eval(File.read(recipe_rb))
              deps += @included_recipes
            rescue => e
              $stderr.puts "lil_chef ERROR: #{e}"
            end
          end
        end
        @included_recipes = []
      end
      deps.compact.uniq
    end

    def include_recipe(name)
      @included_recipes << name
    end

    attr_reader :node
  end

  def initialize(cookbooks_dir, packer_templates_dir)
    @cookbooks_dir = cookbooks_dir
    @packer_templates_dir = packer_templates_dir
  end

  def self.hacketytest!(argv: ARGV)
    new(argv.shift, argv.shift).dostuff(argv)
    0
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
    to_trigger = []
    filenames.map! { |f| f.gsub(%r{^[./]+}, '') }

    packer_templates.each do |template, run_list_cookbooks|
      run_list_cookbooks.each do |cb|
        cb_files = Array(cookbooks.files(cb))
        next if cb_files.empty?
        to_trigger << template unless (filenames & cb_files).empty?
      end
    end

    puts to_trigger
  end

  private

  attr_reader :cookbooks_dir, :packer_templates_dir

  def packer_templates
    @packer_templates ||= PackerTemplates.load(
      [cookbooks_dir], packer_templates_dir
    )
  end

  def cookbooks
    @cookbooks ||= Cookbooks.load(cookbooks_dir)
  end
end

exit(LilChef.hacketytest!) if $PROGRAM_NAME == __FILE__
