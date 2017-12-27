require 'lolcommits/plugin/configuration_helper'

module Lolcommits
  module Plugin
    class Base
      include Lolcommits::Plugin::ConfigurationHelper

      attr_accessor :runner, :configuration, :options

      def initialize(runner: nil, config: {})
        self.runner = runner
        self.configuration = config || {}
        self.options = ['enabled']
      end

      def run_pre_capture; end

      def run_post_capture; end

      def run_capture_ready; end

      ##
      # Prompts the user to configure the plugin's options.
      #
      # Available options can be set in either an Array (@options instance var)
      # or a Hash (override the `default_options` method)
      #
      # Using a Hash gives you the added benefits of being able to define nested
      # options and/or include default values.
      #
      # Alternatively you can override this method entirely to customise the
      # configuration process. If you do this be sure to call super first,
      # asking the user to set the default `enabled` option.
      #
      # `configure_option_hash` will iterate over all option keys and build a
      # configuration hash, prompting the user for input.
      #
      # Lolcommits will save this configuration hash to its default config file
      # (YAML). This config Hash is loaded and parsed during the capturing
      # process and available in the plugin class via the `configuration` hash.
      #
      # A helpful `parse_user_input` method is available to help parse strings
      # from STDIN (into boolean, integer or nil values).
      #
      # @return [Hash] the configured plugin options
      #
      def configure_options!
        configure_option_hash(default_options)
      end

      def default_options
        # maps an array of option names to hash keys (with nil values)
        Hash[options.map { |key, _value| [key, nil] }]
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

      private

      def configure_option_hash(option_hash, spacers = 0)
        option_hash.keys.reduce({}) do |acc, option|
          option_value = option_hash[option]
          prefix       = '  ' * spacers
          if option_value.is_a?(Hash)
            puts "#{prefix}#{option}:\n"
            acc.merge(option => configure_option_hash(option_value, (spacers + 1)))
          else
            print "#{prefix}#{option.to_s.tr('_', ' ')}#{" (#{option_value})" unless option_value.nil?}: "
            input_val = parse_user_input(gets.chomp.strip)
            input_val = option_value if input_val.nil?

            # if not enabled, disable and abort
            return { option => false } if option == 'enabled' && input_val != true

            acc.merge(option => input_val)
          end
        end
      end
    end
  end
end
