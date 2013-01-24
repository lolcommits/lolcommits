module Lolcommits
  class Plugin
    include Methadone::CLILogging
    attr_accessor :default, :name, :runner, :options

    def configuration
      config = runner.config.user_configuration
      return Hash.new if config.nil?
      config[self.name] || Hash.new
    end

    def initialize(runner)
      self.runner = runner
      self.options = ['enabled']

      plugdebug "Initializing"
    end

    def is_enabled?
      enabled_config = configuration['enabled']
      return self.default if enabled_config.nil? || enabled_config == ''
      return enabled_config
    end


    def execute
      if is_enabled?
        plugdebug "I am enabled, about to run"
        run
      else
        plugdebug "Disabled, doing nothing for execution"
      end
    end

    # uniform debug logging output for plugins
    def plugdebug(msg)
      debug("Plugin: #{self.class.to_s}: " + msg)
    end
  end
end
