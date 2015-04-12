# -*- encoding : utf-8 -*-
require 'yaml'
require 'oauth'

# twitter gem currently spams stdout when activated, surpress warnings just during the inital require
original_verbose, $VERBOSE = $VERBOSE, nil # Supress warning messages.
require 'twitter'
$VERBOSE = original_verbose # activate warning messages again.

module Lolcommits
  class LolTwitter < Plugin
    TWITTER_API_ENDPOINT    = 'https://api.twitter.com'
    TWITTER_CONSUMER_KEY    = 'qc096dJJCxIiqDNUqEsqQ'
    TWITTER_CONSUMER_SECRET = 'rvjNdtwSr1H0TvBvjpk6c4bvrNydHmmbvv7gXZQI'
    TWITTER_RETRIES         = 2
    TWITTER_PIN_REGEX       = /^\d{4,}$/ # 4 or more digits
    DEFAULT_SUFFIX          = '#lolcommits'

    def run_postcapture
      return unless valid_configuration?
      tweet = build_tweet(runner.message)

      attempts = 0
      begin
        attempts += 1
        puts "Tweeting: #{tweet}"
        debug "--> Tweeting! (attempt: #{attempts}, tweet length: #{tweet.length} chars)"
        if client.update_with_media(tweet, File.open(runner.main_image, 'r'))
          puts "\t--> Tweet Sent!"
        end
      rescue Twitter::Error::ServerError,
             Twitter::Error::ClientError => e
        debug "Tweet FAILED! #{e.class} - #{e.message}"
        retry if attempts < TWITTER_RETRIES
        puts "ERROR: Tweet FAILED! (after #{attempts} attempts) - #{e.message}"
      end
    end

    def build_tweet(commit_message)
      prefix = config_with_default('prefix', '')
      suffix = " #{config_with_default('suffix', DEFAULT_SUFFIX)}"
      prefix = "#{prefix} " unless prefix.empty?

      available_commit_msg_size = max_tweet_size - (prefix.length + suffix.length)
      if commit_message.length > available_commit_msg_size
        commit_message = "#{commit_message[0..(available_commit_msg_size - 3)]}..."
      end

      "#{prefix}#{commit_message}#{suffix}"
    end

    def configure_options!
      options = super
      # ask user to configure tokens if enabling
      if options['enabled']
        auth_config = configure_auth!
        if auth_config
          options = options.merge(auth_config).merge(configure_prefix_suffix)
        else
          return # return nil if configure_auth failed
        end
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

    def configure_prefix_suffix
      print "\n3) Prefix all tweets with something? e.g. @user (leave blank for no prefix): "
      prefix = STDIN.gets.strip
      print "\n4) End all tweets with something? e.g. #hashtag (leave blank for default suffix #{DEFAULT_SUFFIX}): "
      suffix = STDIN.gets.strip

      config = {}
      config['prefix'] = prefix unless prefix.empty?
      config['suffix'] = suffix unless suffix.empty?
      config
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

    def max_tweet_size
      139 - client.configuration.characters_reserved_per_media
    end

    def self.name
      'twitter'
    end

    def self.runner_order
      :postcapture
    end
  end
end
