module Lolcommits
  module Plugin
    class Base
      attr_accessor :runner, :configuration, :options

      def initialize(runner: nil, config: {})
        self.runner = runner
        self.configuration = config || {}
        self.options = ['enabled']
      end

      def execute_pre_capture
        return unless configured_and_enabled?
        debug 'I am enabled, about to run pre capture'
        run_pre_capture
      end

      def execute_post_capture
        return unless configured_and_enabled?
        debug 'I am enabled, about to run post capture'
        run_post_capture
      end

      def execute_capture_ready
        return unless configured_and_enabled?
        debug 'I am enabled, about to run capture ready'
        run_capture_ready
      end

      def run_pre_capture; end

      def run_post_capture; end

      def run_capture_ready; end

      # ask for plugin options
      def configure_options!
        options.reduce({}) do |acc, option|
          print "#{option}: "
          val = parse_user_input(gets.strip)
          # if not enabled, abort and disable
          break { option => false } if option == 'enabled' && val != true
          acc.merge(option => val)
        end
      end

      def parse_user_input(str)
        # handle for bools, strings, ints and blanks
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

      def configured_and_enabled?
        valid_configuration? && enabled?
      end

      def enabled?
        configuration['enabled'] == true
      end

      # check config is valid
      def valid_configuration?
        configured?
      end

      # empty plugin configuration
      def configured?
        !configuration.empty?
      end

      # uniform puts and print for plugins
      # dont puts or print if the runner wants to be silent (stealth mode)
      def puts(*args)
        return if runner && runner.capture_stealth
        super(args)
      end

      def print(args)
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
        super("#{self.class}: " + msg)
      end

      # Returns position(s) of when a plugin should run during the capture
      # process.
      #
      # Defines when the plugin will execute in the capture process. This must
      # be defined, if the method returns nil, or [] the plugin will never run.
      # Three hook positions exist, your plugin code can execute in one or more
      # of these.
      #
      # @return [Array] the position(s) (:pre_capture, :post_capture,
      # :capture_ready)
      #
      def self.runner_order
        []
      end
    end
  end
end
