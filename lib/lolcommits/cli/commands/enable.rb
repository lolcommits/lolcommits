require 'lolcommits/cli/command'
require 'lolcommits/cli/fatals'

module Lolcommits
  module CLI
    class EnableCommand < Command
      def execute
        # TODO: rationalize how to pass options to Installation.do_enable
        # previous version relied on all flags being global (yikes)
        Installation.do_enable
      end
    end
  end
end
