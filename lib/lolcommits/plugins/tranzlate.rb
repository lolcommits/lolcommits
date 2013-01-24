require "tranzlate/lolspeak"

module Lolcommits
  class Tranzlate < Plugin
    def initialize(runner)
      super

      self.name    = 'tranzlate'
      self.default = false
    end

    def run
      plugdebug "Commit message before: #{self.runner.message}"
      self.runner.message = self.runner.message.tranzlate
      plugdebug "Commit message after: #{self.runner.message}"
    end
  end
end
