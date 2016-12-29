# -*- encoding : utf-8 -*-
require 'rest_client'
require 'pp'
require 'json'

module Lolcommits
  module Plugin
    class Lolsrv < Base
      def initialize(runner)
        super
        options << 'server'
      end

      def run_postcapture
        return unless valid_configuration?
        fork { sync }
      end

      def configured?
        !configuration['enabled'].nil? && configuration['server']
      end

      def sync
        existing = existing_lols
        return unless existing.nil?
        Dir[runner.config.loldir + '/*.{jpg,gif}'].each do |item|
          sha = File.basename(item, '.*')
          upload(item, sha) unless existing.include?(sha) || sha == 'tmp_snapshot'
        end
      end

      def existing_lols
        lols = JSON.parse(RestClient.get(configuration['server'] + '/lols'))
        lols.map { |lol| lol['sha'] }
      rescue => e
        log_error(e, "ERROR: existing lols could not be retrieved #{e.class} - #{e.message}")
        return nil
      end

      def upload(file, sha)
        RestClient.post(configuration['server'] + '/uplol',
                        lol: File.new(file),
                        url: runner.vcs_info.url + sha,
                        repo: runner.vcs_info.repo,
                        date: File.ctime(file),
                        sha: sha)
      rescue => e
        log_error(e, "ERROR: Upload of lol #{sha} FAILED #{e.class} - #{e.message}")
      end

      def self.name
        'lolsrv'
      end

      def self.runner_order
        :postcapture
      end
    end
  end
end
