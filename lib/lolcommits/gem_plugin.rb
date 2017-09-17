module Lolcommits
  class GemPlugin
    attr_accessor :gem_spec, :required

    def initialize(gem_spec)
      @gem_spec = gem_spec
    end

    # activate the plugin (require the gem - enables/loads the plugin
    # immediately at point of call if not already required)
    def activate!
      begin
        require gem_path unless required?
      rescue LoadError => e
        warn "Found plugin #{name}, but could not require gem '#{gem_name}'"
        warn e
      rescue StandardError => e
        warn "require gem '#{gem_name}' failed with: #{e}"
      end

      @required = true
    end

    alias required? required

    def supported?
      # false if the plugin gem does not support this version of Lolcommits
      lolcommits_version = Gem::Version.new(::Lolcommits::VERSION)
      gem_spec.dependencies.each do |dependency|
        if dependency.name == Lolcommits::GEM_NAME
          return dependency.requirement.satisfied_by?(lolcommits_version)
        end
      end
      true
    end

    def name
      gem_name.split('-', 2).last
    end

    def plugin_klass
      self.class.const_get(plugin_klass_name)
    rescue StandardError => e
      warn "failed to load constant from plugin gem '#{plugin_klass_name}: #{e}'"
    end

    def gem_name
      gem_spec.name
    end

    private

    def gem_path
      gem_name.gsub(/-|_/, '/')
    end

    def plugin_klass_name
      gem_path.split('/').map(&:capitalize).join('::')
    end
  end
end
