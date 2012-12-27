require 'rest_client'

module Lolcommits
  class Uploldz < Plugin
    attr_accessor :endpoint

    def initialize(runner)
      super

      self.name     = 'uploldz'
      self.default  = false
      self.options.concat(['endpoint'])
    end

    def run
      if configuration['endpoint'].empty?
        puts "Endpoint URL is empty, please run lolcommits --config to add one."
      else
        RestClient.post(configuration['endpoint'],
          :file => File.new(self.runner.main_image),
          :repo => self.runner.repo)
      end

    end
  end
end
