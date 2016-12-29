# -*- encoding : utf-8 -*-
require 'rest_client'
require 'base64'

module Lolcommits
  module Plugin
    class Uploldz < Base
      attr_accessor :endpoint

      def initialize(runner)
        super
        options.concat(
          %w(
            endpoint
            optional_key
            optional_http_auth_username
            optional_http_auth_password
          )
        )
      end

      def run_postcapture
        return unless valid_configuration?

        if !runner.vcs_info || runner.vcs_info.repo.empty?
          puts 'Repo is empty, skipping upload'
        else
          debug "Posting capture to #{configuration['endpoint']}"
          RestClient.post(
            configuration['endpoint'],
            {
              file: File.new(runner.main_image),
              message: runner.message,
              repo: runner.vcs_info.repo,
              author_name: runner.vcs_info.author_name,
              author_email: runner.vcs_info.author_email,
              sha: runner.sha,
              key: configuration['optional_key']
            },
            Authorization: authorization_header
          )
        end
      rescue => e
        log_error(e, "ERROR: RestClient POST FAILED #{e.class} - #{e.message}")
      end

      def configured?
        !configuration['enabled'].nil? && configuration['endpoint']
      end

      def authorization_header
        user     = configuration['optional_http_auth_username']
        password = configuration['optional_http_auth_password']
        return unless user || password

        'Basic ' + Base64.encode64("#{user}:#{password}").chomp
      end

      def self.name
        'uploldz'
      end

      def self.runner_order
        :postcapture
      end
    end
  end
end
