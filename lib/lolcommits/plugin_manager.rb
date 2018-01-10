module Lolcommits
  class PluginManager
    GEM_NAME_PREFIX = /^lolcommits-/

    def self.init
      pm = new
      pm.load_plugins
      pm
    end

    attr_reader :plugins

    def initialize
      @plugins = []
    end

    # find and require all plugins
    def load_plugins
      find_plugins
      @plugins.map(&:activate!)
    end

    def plugins_for(position)
      @plugins.select do |plugin|
        Array(plugin.plugin_klass.runner_order).include?(position)
      end
    end

    # @return [Lolcommits::Plugin] finds the first plugin matching name
    def find_by_name(name)
      @plugins.find { |plugin| plugin.name =~ /^#{name}/ } unless name.empty?
    end

    def plugin_names
      @plugins.map(&:name).sort
    end

    private

    # @return [Array] find all installed and supported plugins, populate
    #   @plugins array and return it
    def find_plugins
      find_gems.map do |gem|
        plugin = GemPlugin.new(gem)
        @plugins << plugin if plugin.supported? && !plugin_located?(plugin)
      end

      @plugins
    end

    # @return [Array] find all installed gems matching GEM_NAME_PREFIX
    def find_gems
      gem_list.select { |gem| gem.name =~ GEM_NAME_PREFIX }
    end

    def plugin_located?(plugin)
      @plugins.any? { |existing| existing.gem_name == plugin.gem_name }
    end

    def gem_list
      Gem.refresh
      Gem::Specification.respond_to?(:each) ? Gem::Specification : Gem.source_index.find_name('')
    end
  end
end
