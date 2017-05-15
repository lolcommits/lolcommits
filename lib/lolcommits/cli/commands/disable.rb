require 'lolcommits/cli/command'
require 'lolcommits/cli/fatals'

module Lolcommits
  module CLI

    class DisableCommand < Command
      def execute
        Fatals.die_if_not_vcs_repo!
        Installation.do_disable
      end
    end

  end
end
