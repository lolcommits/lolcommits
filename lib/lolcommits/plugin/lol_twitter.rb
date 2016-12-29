# -*- encoding : utf-8 -*-
require 'yaml'
require 'oauth'
require 'simple_oauth'
require 'rest_client'
require 'addressable/uri'

module Lolcommits
  module Plugin
    class LolTwitter < Base
      TWITTER_API_ENDPOINT         = 'https://api.twitter.com'.freeze
      TWITTER_CONSUMER_KEY         = 'qc096dJJCxIiqDNUqEsqQ'.freeze
      TWITTER_CONSUMER_SECRET      = 'rvjNdtwSr1H0TvBvjpk6c4bvrNydHmmbvv7gXZQI'.freeze
      TWITTER_RESERVED_MEDIA_CHARS = 24
      TWITTER_RETRIES              = 2
      TWITTER_PIN_REGEX            = /^\d{4,}$/ # 4 or more digits
      DEFAULT_SUFFIX               = '#lolcommits'.freeze

      def run_postcapture
        return unless valid_configuration?
        tweet = build_tweet(runner.message)

        attempts = 0
        begin
          attempts += 1
          puts "Tweeting: #{tweet}"
          debug "--> Tweeting! (attempt: #{attempts}, tweet length: #{tweet.length} chars)"
          post_tweet(tweet, File.open(runner.main_image, 'r'))
        rescue StandardError => e
          debug "Tweet FAILED! #{e.class} - #{e.message}"
          retry if attempts < TWITTER_RETRIES
          puts "ERROR: Tweet FAILED! (after #{attempts} attempts) - #{e.message}"
        end
      end

      def post_url
        # TODO: this endpoint is deprecated, use the new approach instead
        # https://dev.twitter.com/rest/reference/post/statuses/update_with_mediath_media
        @post_url ||= TWITTER_API_ENDPOINT + '/1.1/statuses/update_with_media.json'
      end

      def post_tweet(status, media)
        RestClient.post(
          post_url,
          {
            'media[]' => media,
            'status'  => status
          }, Authorization: oauth_header
        )
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
          return unless auth_config
          options = options.merge(auth_config).merge(configure_prefix_suffix)
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
          access_token = request_token.get_access_token(oauth_verifier: twitter_pin)
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

      def oauth_header
        uri = Addressable::URI.parse(post_url)
        SimpleOAuth::Header.new(:post, uri, {}, oauth_credentials)
      end

      def oauth_credentials
        {
          consumer_key: TWITTER_CONSUMER_KEY,
          consumer_secret: TWITTER_CONSUMER_SECRET,
          token: configuration['access_token'],
          token_secret: configuration['secret']
        }
      end

      def oauth_consumer
        @oauth_consumer ||= OAuth::Consumer.new(
          TWITTER_CONSUMER_KEY,
          TWITTER_CONSUMER_SECRET,
          site: TWITTER_API_ENDPOINT,
          request_endpoint: TWITTER_API_ENDPOINT,
          sign_in: true
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
        139 - TWITTER_RESERVED_MEDIA_CHARS
      end

      def self.name
        'twitter'
      end

      def self.runner_order
        :postcapture
      end
    end
  end
end
