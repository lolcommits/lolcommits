require 'yaml'
require 'oauth'

# twitter gem currently spams stdout when activated, surpress warnings just during the inital require
original_verbose, $VERBOSE = $VERBOSE, nil # Supress warning messages.
require 'twitter'
$VERBOSE = original_verbose # activate warning messages again.

module Lolcommits
  class LolTwitter < Plugin

    TWITTER_CONSUMER_KEY    = 'qc096dJJCxIiqDNUqEsqQ'
    TWITTER_CONSUMER_SECRET = 'rvjNdtwSr1H0TvBvjpk6c4bvrNydHmmbvv7gXZQI'
    TWITTER_RETRIES         = 2
    TWITTER_PIN_REGEX       = /^\d{4,}$/ # 4 or more digits

    def run
      return unless valid_configuration?

      attempts = 0

      begin
        attempts += 1
        tweet = build_tweet(self.runner.message)
        puts "Tweeting: #{tweet}"
        debug "--> Tweeting! (attempt: #{attempts}, tweet size: #{tweet.length} chars)"
        if client.update_with_media(tweet, File.open(self.runner.main_image, 'r'))
          puts "\t--> Tweet Sent!"
        end
      rescue Twitter::Error::InternalServerError,
               Twitter::Error::BadRequest,
               Twitter::Error::ClientError => e
        debug "Tweet FAILED! #{e.class} - #{e.message}"
        retry if attempts < TWITTER_RETRIES
        puts "ERROR: Tweet FAILED! (after #{attempts} attempts) - #{e.message}"
      end
    end

    def build_tweet(commit_message, tag = "#lolcommits")
      available_commit_msg_size = max_tweet_size - (tag.length + 1)
      if commit_message.length > available_commit_msg_size
        commit_message = "#{commit_message[0..(available_commit_msg_size-3)]}..."
      end
      "#{commit_message} #{tag}"
    end

    def configure_options!
      options = super
      # ask user to configure tokens if enabling
      if options['enabled'] == true
        if auth_config = configure_auth!
          options.merge!(auth_config)
        else
          # return nil if configure_auth failed
          return
        end
      end
      return options
    end

    def configure_auth!
      puts "---------------------------"
      puts "Need to grab twitter tokens"
      puts "---------------------------"

      consumer = OAuth::Consumer.new(TWITTER_CONSUMER_KEY,
                                     TWITTER_CONSUMER_SECRET,
                                     :site => 'https://api.twitter.com',
                                     :request_endpoint => 'https://api.twitter.com',
                                     :sign_in => true)

      request_token = consumer.get_request_token
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
        OAuth::RequestToken.new(consumer, rtoken, rsecret)
        access_token = request_token.get_access_token(:oauth_verifier => twitter_pin)
      rescue OAuth::Unauthorized
        puts "\nERROR: Twitter PIN Auth FAILED!"
        return
      end

      if access_token.token && access_token.secret
        print "\n3) Thanks! Twitter Auth Succeeded\n"
        return { 'access_token' => access_token.token,
                 'secret'       => access_token.secret }
      end
    end

    def is_configured?
      !configuration['enabled'].nil? &&
        configuration['access_token'] &&
        configuration['secret']
    end

    def client
      @client ||= Twitter::Client.new(
        :consumer_key       => TWITTER_CONSUMER_KEY,
        :consumer_secret    => TWITTER_CONSUMER_SECRET,
        :oauth_token        => configuration['access_token'],
        :oauth_token_secret => configuration['secret']
      )
    end

    def max_tweet_size
      139 - client.configuration.characters_reserved_per_media
    end

    def self.name
      'twitter'
    end
  end
end
