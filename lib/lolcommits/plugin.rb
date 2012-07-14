module Lolcommits
  class Plugin
    attr_accessor :default, :name, :runner

    def configuration
      Configuration.user_configuration[self.name] || Hash.new
    end

    def initialize(runner)
      self.runner = runner
    end

    def is_enabled?
      enabled_config = configuration['enabled']
      return self.default if enabled_config.nil? || enabled_config == ''
      return enabled_config
    end


    def execute
      if is_enabled?
        run
      end
    end
  end
end
