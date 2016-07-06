require 'thread'

module Downstreams
  class ChefDependencyFinder
    def initialize(run_list, cookbook_path)
      @run_list = Array(run_list)
      @cookbook_path = cookbook_path
    end

    def find
      found = run_list.map do |cb|
        cookbook_name = cb.gsub(/^recipe\[/, '').delete(']').gsub(/::.*/, '')
        find_dependency_cookbooks(cookbook_name)
      end

      found.flatten.sort.uniq
    end

    private

    attr_reader :run_list, :cookbook_path

    def find_dependency_cookbooks(cookbook_name)
      deps = [cookbook_name]
      sem = Mutex.new
      cookbook_path.each do |cookbooks_dir|
        recipes_dir = File.join(cookbooks_dir, cookbook_name, 'recipes')
        next unless File.exist?(recipes_dir)
        Dir.glob(File.join(recipes_dir, '*.rb')) do |recipe_rb|
          sem.synchronize do
            begin
              @included_recipes = []
              instance_eval(File.read(recipe_rb))
              deps += @included_recipes.map { |n| n.gsub(/::.*/, '') }
            rescue => e
              $stderr.puts "ERROR:#{recipe_rb.sub("#{cookbooks_dir}/", '')}: #{e}"
            end
          end
        end
        @included_recipes = []
      end
      deps.compact.uniq
    end

    include ChefFakeRecipeMethods
  end
end
