# -*- encoding : utf-8 -*-
require 'yammer'
require 'rest_client'

# https://developer.yammer.com/oauth2-quickstart/
YAMMER_CLIENT_ID        = 'bgORyeKtnjZJSMwp8oln9g'.freeze
YAMMER_CLIENT_SECRET    = 'oer2WdGzh74a5QBbW3INUxblHK3yg9KvCZmiBa2r0'.freeze
YAMMER_ACCESS_TOKEN_URL = 'https://www.yammer.com/oauth2/access_token.json'.freeze
YAMMER_RETRY_COUNT      = 2

module Lolcommits
  module Plugin
    class LolYammer < Base
      def self.name
        'yammer'
      end

      def self.runner_order
        :postcapture
      end

      def configured?
        !configuration['access_token'].nil?
      end

      def configure_access_token
        print "Open the URL below and copy the `code` param from query after redirected, enter it as `access_token`:\n"
        print "https://www.yammer.com/dialog/oauth?client_id=#{YAMMER_CLIENT_ID}&response_type=code\n"
        print 'Enter code param from the redirected URL, then press enter: '
        code = gets.to_s.strip

        url = YAMMER_ACCESS_TOKEN_URL
        debug "access_token url: #{url}"
        params = {
          'client_id' => YAMMER_CLIENT_ID,
          'client_secret' => YAMMER_CLIENT_SECRET,
          'code' => code
        }
        debug "params : #{params.inspect}"
        result = JSON.parse(RestClient.post(url, params))
        debug "response : #{result.inspect}"
        # no need for 'return', last line is always the return value
        { 'access_token' => result['access_token']['token'] }
      end

      def configure_options!
        options = super
        # ask user to configure tokens if enabling
        if options['enabled']
          auth_config = configure_access_token
          return unless auth_config
          options.merge!(auth_config)
        end
        options
      end

      def run_postcapture
        return unless valid_configuration?

        commit_msg = runner.message
        post = "#{commit_msg} #lolcommits"
        puts "Yammer post: #{post}" unless runner.capture_stealth

        Yammer.configure do |c|
          c.client_id = YAMMER_CLIENT_ID
          c.client_secret = YAMMER_CLIENT_SECRET
        end

        client = Yammer::Client.new(access_token: configuration['access_token'])

        retries = YAMMER_RETRY_COUNT
        begin
          lolimage = File.new(runner.main_image)
          response = client.create_message(post, attachment1: lolimage)
          debug response.body.inspect
          puts "\t--> Status posted!" if response
        rescue => e
          retries -= 1
          retry if retries > 0
          puts "Status not posted - #{e.message}"
          puts 'Try running config again:'
          puts "\tlolcommits --config --plugin yammer"
        end
      end
    end
  end
end
