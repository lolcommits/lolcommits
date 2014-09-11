# -*- encoding : utf-8 -*-
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

    def run_postcapture
      return unless valid_configuration?

      attempts = 0

      tweet = build_tweet(self.runner.message)

      begin
        attempts += 1
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

    def build_tweet(commit_message)
      if configuration['prefix']
        prefix = configuration['prefix']
      else # this case may arise if the user has the old style of config.yml file stored
        prefix = ""
      end
      if configuration['suffix']
        suffix = configuration['suffix']
      else # this case may arise if the user has the old style of config.yml file stored
        suffix = ""
      end
      available_commit_msg_size = max_tweet_size - (prefix.length + suffix.length + 2)
      if commit_message.length > available_commit_msg_size
        commit_message = "#{commit_message[0..(available_commit_msg_size - 3)]}..."
      end
      "#{prefix} #{commit_message} #{suffix}"
    end

    def configure_options!
      options = super
      # ask user to configure tokens if enabling
      if options['enabled'] == true
        # note that (for now) configure_auth! also includes setting prefix and suffix
        auth_config = configure_auth!
        if auth_config
          options.merge!(auth_config)
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

      print "\n3) Thanks! Twitter Auth Succeeded\n"

      # these should probably not go in the configure_auth! (since they aren't to do with authentication)
      print "\n4) If you would like to precede your tweets with something (such as an @user), enter it now: "
      prefix = STDIN.gets.strip
      print "\n5) If you would like to end your tweets with something (such as a hashtag), enter it now: #lolcommits "
      suffix = "#lolcommits " + STDIN.gets.strip
      suffix = suffix.strip

      if access_token.token && access_token.secret
        return { 'access_token' => access_token.token,
                 'secret'       => access_token.secret,
                 'prefix'       => prefix,
                 'suffix'       => suffix }
      end
    end

    def configured?
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

    def self.runner_order
      :postcapture
    end
  end
end
