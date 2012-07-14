module Lolcommits
  class Tranzlate < Plugin
    def initialize(runner)
      super

      self.name    = 'tranzlate'
      self.default = false
    end

    def run
      self.runner.message = self.runner.message.tranzlate
    end
  end
end
