# -*- encoding : utf-8 -*-
require 'rest_client'

SLACK_FILE_UPLOAD_URL = 'https://slack.com/api/files.upload'
SLACK_RETRY_COUNT = 2

module Lolcommits
  class LolSlack < Plugin
    def self.name
      'slack'
    end

    def self.runner_order
      :postcapture
    end

    def configured?
      !configuration['access_token'].nil?
    end

    def configure
      print "Open the URL below and issue a token for your user:\n"
      print "https://api.slack.com/web\n"
      print "Enter the generated token below, then press enter: (e.g. xxxx-xxxxxxxxx-xxxx) \n"
      code = STDIN.gets.to_s.strip
      print "Enter a comma-seperated list of channel IDs to post images in, then press enter: (e.g. C1234567890,C1234567890)\n"
      channels = STDIN.gets.to_s.strip

      { 'access_token' => code,
        'channels' => channels }
    end

    def configure_options!
      options = super
      if options['enabled']
        config = configure
        options.merge!(config)
      end
      options
    end

    def run_postcapture
      return unless valid_configuration?

      retries = SLACK_RETRY_COUNT
      begin

        response = RestClient.post(
          SLACK_FILE_UPLOAD_URL,
          :file         => File.new(runner.main_image),
          :token        => configuration['access_token'],
          :filetype     => 'jpg',
          :filename     => runner.sha,
          :title        => runner.message + "[#{runner.git_info.repo}]",
          :channels     => configuration['channels'])

        debug response
      rescue => e
        retries -= 1
        retry if retries > 0
        puts "Posting to slack failed - #{e.message}"
        puts 'Try running config again:'
        puts "\tlolcommits --config --plugin slack"
      end
    end
  end
end