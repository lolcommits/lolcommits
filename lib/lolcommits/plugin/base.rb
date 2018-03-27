require 'lolcommits/plugin/configuration_helper'

module Lolcommits
  module Plugin
    class Base
      include Lolcommits::Plugin::ConfigurationHelper

      attr_accessor :runner, :configuration, :options, :name

      def initialize(runner: nil, name: nil, config: {})
        self.runner = runner
        self.name = name || self.class.to_s
        self.configuration = config || {}
        self.options = [:enabled]
      end

      def run_pre_capture; end

      def run_post_capture; end

      def run_capture_ready; end

      ##
      # Prompts the user to configure all plugin options.
      #
      # Available options can be defined in an Array (@options instance var)
      # and/or a Hash (by overriding the `default_options` method).
      #
      # By default (on initialize), `@options` is set with `[:enabled]`. This is
      # mandatory since `enabled?` checks this option is true before running any
      # capture hooks.
      #
      # Using a Hash to define default options allows you to:
      #
      #  - including default values
      #  - define nested options, user is prompted for each nested option key
      #
      # `configure_option_hash` will iterate over all options prompting the user
      # for input and building the configuration Hash.
      #
      # Lolcommits will save this Hash to a YAML file. During the capture
      # process the configuration is loaded, parsed and available in the plugin
      # class as `@configuration`. Or if you want to fall back to default
      # values, you should use `config_option` to fetch option values.
      #
      # Alternatively you can override this method entirely to customise the
      # process. A helpful `parse_user_input` method is available to help parse
      # strings from STDIN (into boolean, integer or nil values).
      #
      # @return [Hash] the configured plugin options
      def configure_options!
        configure_option_hash(
          Hash[options.map { |key, _value| [key, nil] }].merge(default_options)
        )
      end

      def default_options
        {}
      end

      def config_option(*keys)
        configuration.dig(*keys) || default_options.dig(*keys)
      end

      def enabled?
        configuration[:enabled] == true
      end

      # check config is valid
      def valid_configuration?
        !configuration.empty?
      end

      # uniform puts and print for plugins
      # dont puts or print if the runner wants to be silent (stealth mode)
      def puts(*args)
        return if runner && runner.capture_stealth
        super(*args)
      end

      def print(*args)
        return if runner && runner.capture_stealth
        super(*args)
      end

      # helper to log errors with a message via debug
      def log_error(error, message)
        debug message
        debug error.backtrace.join("\n")
      end

      # uniform debug logging for plugins
      def debug(msg)
        super("#{self.class}: " + msg)
      end

      private

      def configure_option_hash(option_hash, spacing_count = 0)
        option_hash.keys.reduce({}) do |acc, option|
          option_value = option_hash[option]
          prefix       = '  ' * spacing_count
          if option_value.is_a?(Hash)
            puts "#{prefix}#{option}:\n"
            acc.merge(option => configure_option_hash(option_value, (spacing_count + 1)))
          else
            print "#{prefix}#{option.to_s.tr('_', ' ')}#{" (#{option_value})" unless option_value.nil?}: "
            user_value = parse_user_input(gets.chomp.strip)

            # if not enabled, disable and return without setting more options
            # useful with nested hash configs, place enabled as first sub-option
            # if answer is !true, no further sub-options will be prompted for
            return { option => false } if option == :enabled && user_value != true

            acc.merge(option => user_value)
          end
        end
      end
    end
  end
end
