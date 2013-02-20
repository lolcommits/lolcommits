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
      repo = self.runner.repo.to_s
      if configuration['endpoint'].empty?
        puts "Endpoint URL is empty, please run lolcommits --config to add one."
      elsif repo.empty?
        puts "Repo is empty, skipping upload"
      else
        plugdebug "Calling " + configuration['endpoint'] + " with repo " + repo
        RestClient.post(configuration['endpoint'], 
          :file => File.new(self.runner.main_image),
          :repo => repo)
      end

    end
  end
end
