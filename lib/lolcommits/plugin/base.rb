# -*- encoding : utf-8 -*-
module Lolcommits
  module Plugin
    class Base
      attr_accessor :runner, :options

      def initialize(runner)
        debug 'Initializing'
        self.runner = runner
        self.options = ['enabled']
      end

      def execute_precapture
        if enabled?
          debug 'I am enabled, about to run precapture'
          run_precapture
        else
          debug 'Disabled, doing nothing for precapture execution'
        end
      end

      def execute_postcapture
        if enabled?
          debug 'I am enabled, about to run postcapture'
          run_postcapture
        else
          debug 'Disabled, doing nothing for postcapture execution'
        end
      end

      def run_precapture
        debug 'base plugin, does nothing to anything'
      end

      def run_postcapture
        debug 'base plugin, does nothing to anything'
      end

      def configuration
        config = runner.config.read_configuration if runner
        return {} unless config
        config[self.class.name] || {}
      end

      # ask for plugin options
      def configure_options!
        puts "Configuring plugin: #{self.class.name}\n"
        options.reduce({}) do |acc, option|
          print "#{option}: "
          val = parse_user_input(STDIN.gets.strip)
          # check enabled option isn't a String
          if (option == 'enabled') && ![true, false].include?(val)
            puts "Aborting - please respond with 'true' or 'false'"
            exit 1
          else
            acc.merge(option => val)
          end
        end
      end

      def parse_user_input(str)
        # cater for bools, strings, ints and blanks
        if 'true'.casecmp(str).zero?
          true
        elsif 'false'.casecmp(str).zero?
          false
        elsif str =~ /^[0-9]+$/
          str.to_i
        elsif str.strip.empty?
          nil
        else
          str
        end
      end

      def enabled?
        configuration['enabled'] == true
      end

      # check config is valid
      def valid_configuration?
        if configured?
          true
        else
          puts "Missing #{self.class.name} config - configure with: lolcommits --config -p #{self.class.name}"
          false
        end
      end

      # empty plugin configuration
      def configured?
        !configuration.empty?
      end

      # uniform puts for plugins
      # dont puts if the runner wants to be silent (stealth mode)
      def puts(*args)
        return if runner && runner.capture_stealth
        super(args)
      end

      # helper to log errors with a message via debug
      def log_error(e, message)
        debug message
        debug e.backtrace.join("\n")
      end

      # uniform debug logging for plugins
      def debug(msg)
        super("Plugin: #{self.class}: " + msg)
      end

      # identifying plugin name (for config, listing)
      def self.name
        'plugin'
      end

      # a plugin requests to be run by the runner in one of the possible positions.
      # valid options are [:precapture, :postcapture]
      def self.runner_order
        nil
      end
    end
  end
end
