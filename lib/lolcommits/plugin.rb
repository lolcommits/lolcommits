module Lolcommits
  class Plugin
    attr_accessor :default, :name, :runner, :options

    def configuration
      config = Configuration.user_configuration
      return Hash.new if config.nil?
      config[self.name] || Hash.new
    end

    def initialize(runner)
      self.runner = runner
      self.options = ['enabled']
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
