require 'methadone'
require 'clamp'

# allow logging from all commands
# TODO: we should now rationalize using Methadone for this vs something for just logging
include Methadone::CLILogging

module Lolcommits
  module CLI

    class EnableCommand < Clamp::Command
      def execute
        # TODO: rationalize how to pass options to Installation.enable
        # previous version relied on all flags being global (yikes)
        puts 'TODO: execute enable'
        exit 1
      end
    end

    class DisableCommand < Clamp::Command
      def execute
        Fatals.die_if_not_vcs_repo!
        Installation.do_disable
      end
    end

    class DevicesCommand < Clamp::Command
      def execute
        puts Platform.device_list
        puts "\n"
        puts 'Specify capture device with --device="NAME" or set $LOLCOMMITS_DEVICE'
      end
    end

    class PluginsCommand < Clamp::Command
      subcommand 'list', 'List all available plugins' do
        def execute
          Configuration.new(PluginManager.init).list_plugins
        end
      end

      subcommand 'config', 'Configure a plugin' do
        parameter 'PLUGIN', 'name of plugin to configure'
        def execute
          Configuration.new(PluginManager.init).do_configure!(plugin)
        end
      end

      subcommand 'show-config', 'show config file' do
        def execute
          puts Configuration.new(PluginManager.init)
        end
      end
    end

    class HistoryCommand < Clamp::Command
      subcommand ['dir', 'path'], 'stored lolcommits for current repo' do
        option '--open', :flag, 'open directory for display in OS'
        def execute
          Fatals.die_if_not_vcs_repo!
          # change_dir_to_root_or_repo!
          config = Configuration.new(PluginManager.init)
          puts config.loldir
          Launcher.open_folder(config.loldir) if open?
        end
      end

      subcommand 'last', 'most recent lolcommit for current repo' do
        option '--open', :flag, 'open file for display in OS'
        def execute
          Fatals.die_if_not_vcs_repo!
          # change_dir_to_root_or_repo!
          config = Configuration.new(PluginManager.init)
          lolimage = Dir.glob(File.join(config.loldir, '*.{jpg,gif}')).max_by { |f| File.mtime(f) }
          if lolimage.nil?
            warn 'No lolcommits have been captured for this repository yet.'
            exit 1
          end
          puts lolimage
          Launcher.open_image(lolimage) if open?
        end
      end

      subcommand 'timelapse', 'generate animated timelapse .gif' do
        def execute
          Fatals.die_if_not_vcs_repo!
          # change_dir_to_root_or_repo!
          config = Configuration.new(PluginManager.init)
          TimelapseGif.new(config).run(options[:period])
        end
      end
    end

    class CaptureCommand < Clamp::Command
      # FIXME: make this option only show on supported platforms
      option '--device', 'NAME', "Optional device name, see `lolcommits devices`.\n",
             environment_variable: 'LOLCOMMITS_DEVICE'

      # FIXED: make this option only show on supported platforms √
      if Platform.can_animate?
        option ['-a', '--animate'], 'SECONDS', "Enable animated .GIF capture for duration.\n",
             environment_variable: 'LOLCOMMITS_ANIMATE',
             default: 0 { |s| Integer(s) }
      end

      option ['-w', '--delay'], 'SECONDS', "Delay capture to enable camera warmup.\n",
             environment_variable: 'LOLCOMMITS_DELAY',
             default: 0 { |s| Integer(s) }

      option '--fork', :flag, "Fork capture process to background.\n",
             environment_variable: 'LOLCOMMITS_FORK',
             default: false

      option '--stealth', :flag, "Capture image in stealth mode, e.g. no output.\n",
             environment_variable: 'LOLCOMMITS_STEALTH',
             default: false

      # TODO: hide [dev mode] options from default help output unless LOLCOMMITS_DEVELOPER is set
      option '--test', :flag, '[dev mode] enable test mode'
      option ['-s', '--sha'], 'SHA', '[dev mode] override commit hash'
      option ['-m', '--msg'], 'MSG', '[dev mode] override commit message'

      def execute
        Fatals.die_if_not_vcs_repo!
        # change_dir_to_root_or_repo!
        config = Configuration.new(PluginManager.init)

        capture_options = {
          capture_delay:    delay,
          capture_stealth:  stealth?,
          capture_device:   device,
          capture_animate:  if Platform.can_animate? then animate else 0 end,
          config:           config
        }
        process_runner = ProcessRunner.new(config)
        process_runner.fork_me?(fork?) do
          if test?
            info '*** Capturing in test mode.'
            capture_options.merge!({
              message: msg || 'this is a test message i didnt really commit something',
              sha: sha || "test-#{rand(10**10)}"
            })
          end

          runner = Lolcommits::Runner.new(capture_options)
          runner.run

          # automatically open the image in test mode
          Launcher.open_image(runner.main_image) if test?
        end
      end
    end

    class LolcommitsCommand < Clamp::Command
      option '--version', :flag, 'display version and exit'

      option '--debug', :flag, 'debug output',
             environment_variable: 'LOLCOMMITS_DEBUG', hidden: false # TODO: hide before v1.0 release?

      subcommand 'enable', 'Install lolcommits for current repository', EnableCommand
      subcommand 'disable', 'Uninstall lolcommits for current repository', DisableCommand
      subcommand 'capture', 'Capture image for most recent git commit', CaptureCommand
      subcommand 'history', 'Historic archives of captured moments', HistoryCommand
      subcommand 'devices', 'Detect and list attached camera devices', DevicesCommand
      subcommand 'plugins', 'List or configure lolcommits plugins', PluginsCommand
    end
  end
end
