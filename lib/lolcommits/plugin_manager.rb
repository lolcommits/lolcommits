# -*- encoding : utf-8 -*-
module Lolcommits
  class PluginManager
    GEM_NAME_PREFIX = /^lolcommits-plugin-/

    def initialize
      @plugins = []
    end

    # @return [Array] find all installed and supported plugins, storing to
    #   @plugins Array, and returns this array
    def locate_plugins
      gem_list.each do |gem|
        next if gem.name !~ GEM_NAME_PREFIX
        plugin_name = gem.name.split('-', 2).last
        plugin = GemPlugin.new(plugin_name, gem.name, gem)

        @plugins << plugin if plugin.supported? && !plugin_located?(plugin)
      end
      @plugins
    end

    # @return [Hash] A hash with all plugin names (minus the prefix) as
    #   keys and Plugin objects as values
    def plugins
      h = {}
      @plugins.each do |plugin|
        h[plugin.name] = plugin
      end
      h
    end

    # require all plugins
    def load_plugins
      @plugins.map(&:activate!)
    end

    private

    def plugin_located?(plugin)
      @plugins.any? { |existing| existing.gem_name == plugin.gem_name }
    end

    def gem_list
      Gem.refresh
      Gem::Specification.respond_to?(:each) ? Gem::Specification : Gem.source_index.find_name('')
    end
  end
end
