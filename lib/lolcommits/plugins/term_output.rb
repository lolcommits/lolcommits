# -*- encoding : utf-8 -*-
require 'rest_client'
require 'base64'

module Lolcommits
  class TermOutput < Plugin

    def initialize(runner)
      super
      options
    end

    def run_postcapture
      return unless valid_configuration?

      if !runner.vcs_info || runner.vcs_info.repo.empty?
        puts 'Repo is empty, skipping output'
      else
        base64 = Base64.encode64(open(runner.main_image) { |io| io.read })

        puts "\e]1337;File=inline=1:#{base64};alt=#{runner.message}\a\n"
      end

    end

    def configured?
      !configuration['enabled'].nil?
    end

    def self.name
      'term_output'
    end

    def self.runner_order
      :postcapture
    end
  end
end
