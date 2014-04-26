# -*- encoding : utf-8 -*-
require 'rest_client'

module Lolcommits
  class Uploldz < Plugin
    attr_accessor :endpoint

    def initialize(runner)
      super
      self.options.concat(['endpoint', 'optional_key'])
    end

    def run_postcapture
      return unless valid_configuration?

      repo = self.runner.repo.to_s
      if repo.empty?
        puts 'Repo is empty, skipping upload'
      else
        debug 'Calling ' + configuration['endpoint'] + ' with repo ' + repo
        RestClient.post(configuration['endpoint'],
                        :file => File.new(self.runner.main_image),
                        :repo => repo,
                        :key => configuration['optional_key'])
      end
    end

    def configured?
      !configuration['enabled'].nil? && configuration['endpoint']
    end

    def self.name
      'uploldz'
    end

    def self.runner_order
      :postcapture
    end
  end
end
