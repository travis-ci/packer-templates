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
      cookbook_path.each do |entry|
        entry.files(%r{.+/#{cookbook_name}/recipes/[^/]+\.rb}).map do |p|
          sem.synchronize do
            begin
              @included_recipes = []
              instance_eval(p.show)
              deps += @included_recipes.map { |n| n.gsub(/::.*/, '') }
            rescue => e
              $stderr.puts "ERROR:#{p.namespaced_path}: #{e}"
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
