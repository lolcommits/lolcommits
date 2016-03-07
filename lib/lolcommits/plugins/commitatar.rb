# -*- encoding : utf-8 -*-
require 'yaml'
require 'oauth'
require 'twitter'

module Lolcommits
  class Commitatar < Plugin
    TWITTER_API_ENDPOINT    = 'https://api.twitter.com'.freeze
    TWITTER_CONSUMER_KEY    = 'qc096dJJCxIiqDNUqEsqQ'.freeze
    TWITTER_CONSUMER_SECRET = 'rvjNdtwSr1H0TvBvjpk6c4bvrNydHmmbvv7gXZQI'.freeze
    TWITTER_RETRIES         = 2
    TWITTER_PIN_REGEX       = /^\d{4,}$/ # 4 or more digits

    def run_postcapture
      return unless valid_configuration?

      attempts = 0
      begin
        attempts += 1
        puts "Updating profile picture..."
        image = File.open(runner.main_image)
        client.update_profile_image image
        puts "Successfully uploaded new profile picture 🌴"
      rescue Twitter::Error::ServerError,
             Twitter::Error::ClientError => e
        debug "Upading avatar failed! #{e.class} - #{e.message}"
        retry if attempts < TWITTER_RETRIES
        puts "ERROR: Updating avatar FAILED! (after #{attempts} attempts) - #{e.message}"
      end
    end

    def configure_options!
      options = super
      # ask user to configure tokens if enabling
      if options['enabled']
        auth_config = configure_auth!
        return unless auth_config
        options = options.merge(auth_config)
      end
      options
    end

    def configure_auth!
      puts '---------------------------'
      puts 'Need to grab twitter tokens'
      puts '---------------------------'

      request_token = oauth_consumer.get_request_token
      rtoken        = request_token.token
      rsecret       = request_token.secret

      print "\n1) Please open this url in your browser to get a PIN for lolcommits:\n\n"
      puts request_token.authorize_url
      print "\n2) Enter PIN, then press enter: "
      twitter_pin = STDIN.gets.strip.downcase.to_s

      unless twitter_pin =~ TWITTER_PIN_REGEX
        puts "\nERROR: '#{twitter_pin}' is not a valid Twitter Auth PIN"
        return
      end

      begin
        debug "Requesting Twitter OAuth Token with PIN: #{twitter_pin}"
        OAuth::RequestToken.new(oauth_consumer, rtoken, rsecret)
        access_token = request_token.get_access_token(:oauth_verifier => twitter_pin)
      rescue OAuth::Unauthorized
        puts "\nERROR: Twitter PIN Auth FAILED!"
        return
      end

      return unless access_token.token && access_token.secret
      puts ''
      puts '------------------------------'
      puts 'Thanks! Twitter Auth Succeeded'
      puts '------------------------------'
      {
        'access_token' => access_token.token,
        'secret'       => access_token.secret
      }
    end

    def configured?
      !configuration['enabled'].nil? &&
        configuration['access_token'] &&
        configuration['secret']
    end

    def client
      @client ||= Twitter::REST::Client.new do |config|
        config.consumer_key        = TWITTER_CONSUMER_KEY
        config.consumer_secret     = TWITTER_CONSUMER_SECRET
        config.access_token        = configuration['access_token']
        config.access_token_secret = configuration['secret']
      end
    end

    def oauth_consumer
      @oauth_consumer ||= OAuth::Consumer.new(
        TWITTER_CONSUMER_KEY,
        TWITTER_CONSUMER_SECRET,
        :site             => TWITTER_API_ENDPOINT,
        :request_endpoint => TWITTER_API_ENDPOINT,
        :sign_in          => true
      )
    end

    def config_with_default(key, default = nil)
      if configuration[key]
        configuration[key].strip.empty? ? default : configuration[key]
      else
        default
      end
    end

    def self.name
      'commitatar'
    end

    def self.runner_order
      :postcapture
    end
  end
end
