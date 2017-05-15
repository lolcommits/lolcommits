require 'lolcommits/cli/command'
require 'lolcommits/cli/fatals'

module Lolcommits
  module CLI
    class EnableCommand < Command
      def execute
        # TODO: rationalize how to pass options to Installation.enable
        # previous version relied on all flags being global (yikes)
        puts 'TODO: execute enable'
        exit 1
      end
    end
  end
end
