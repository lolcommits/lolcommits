require "statsd"

#
# This is just to keep some usage statistics on lolcommits.
#

module Lolcommits
  class StatsD < Plugin
    def initialize(runner)
      super

      self.name    = 'statsd'
      self.default = true
    end

    def run
      $statsd = Statsd.new('23.20.178.143')
      if Configuration.is_fakecapture?
        $statsd.increment 'app.lolcommits.fakecaptures'
      else
        $statsd.increment 'app.lolcommits.captures'
      end
    end
  end
end
