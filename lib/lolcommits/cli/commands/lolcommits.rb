require 'lolcommits/cli/command'

require_relative 'enable'
require_relative 'disable'
require_relative 'capture'
require_relative 'history'
require_relative 'devices'
require_relative 'plugins'

module Lolcommits
  module CLI

    class LolcommitsCommand < Command
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
