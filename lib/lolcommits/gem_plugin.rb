module Lolcommits
  class GemPlugin
    attr_accessor :name, :gem_name, :spec, :required

    def initialize(name, gem_name, spec)
      @name     = name
      @gem_name = gem_name
      @spec     = spec
      @required = false
    end

    # activate the plugin (require the gem - enables/loads the plugin
    # immediately at point of call if not already required)
    def activate!
      begin
        require gem_path unless required?
      rescue LoadError => e
        warn "Found plugin #{gem_name}, but could not require '#{gem_name}'"
        warn e
      rescue => e
        warn "require '#{gem_name}' # Failed, saying: #{e}"
      end

      self.required = true
    end

    alias required? required

    def supported?
      # false if the plugin gem does not support this version of Lolcommits
      lolcommits_version = Gem::Version.new(::Lolcommits::VERSION)
      spec.dependencies.each do |dependency|
        if dependency.name == Lolcommits::GEM_NAME
          return dependency.requirement.satisfied_by?(lolcommits_version)
        end
      end
      true
    end

    private

    def gem_path
      gem_name.gsub(/-|_/, '/')
    end
  end
end
