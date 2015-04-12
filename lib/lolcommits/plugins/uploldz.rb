# -*- encoding : utf-8 -*-
require 'rest_client'

module Lolcommits
  class Uploldz < Plugin
    attr_accessor :endpoint

    def initialize(runner)
      super
      options.concat(%w(endpoint optional_key))
    end

    def run_postcapture
      return unless valid_configuration?

      if runner.git_info.repo.empty?
        puts 'Repo is empty, skipping upload'
      else
        debug "Posting capture to #{configuration['endpoint']}"
        RestClient.post(configuration['endpoint'],
                        :file         => File.new(runner.main_image),
                        :message      => runner.message,
                        :repo         => runner.git_info.repo,
                        :author_name  => runner.git_info.author_name,
                        :author_email => runner.git_info.author_email,
                        :sha          => runner.sha,
                        :key          => configuration['optional_key'])
      end
    rescue => e
      log_error(e, "ERROR: RestClient POST FAILED #{e.class} - #{e.message}")
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
