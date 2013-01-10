require 'yaml'
require 'oauth'

# twitter gem currently spams stdout when activated, surpress warnings just during the inital require
original_verbose, $VERBOSE = $VERBOSE, nil # Supress warning messages.
  require 'twitter'
$VERBOSE = original_verbose # Activate warning messages again.

TWITTER_CONSUMER_KEY = 'qc096dJJCxIiqDNUqEsqQ'
TWITTER_CONSUMER_SECRET = 'rvjNdtwSr1H0TvBvjpk6c4bvrNydHmmbvv7gXZQI'

module Lolcommits

  class LolTwitter < Plugin

    def initialize(runner)
      super
      self.name    = 'twitter'
      self.default = false
    end

    def initial_twitter_auth
      puts "\n--------------------------------------------"
      puts "Need to grab twitter tokens (first time only)"
      puts "---------------------------------------------"

      consumer = OAuth::Consumer.new(TWITTER_CONSUMER_KEY, 
                                     TWITTER_CONSUMER_SECRET,
                                     :site => 'http://api.twitter.com',
                                     :request_endpoint => 'http://api.twitter.com',
                                     :sign_in => true)

      request_token = consumer.get_request_token
      rtoken  = request_token.token
      rsecret = request_token.secret

      puts "\n1.) Open the following url in your browser, get the PIN:\n\n"
      puts request_token.authorize_url
      puts "\n2.) Enter PIN, then press enter:"

      begin
        STDOUT.flush
        twitter_pin = STDIN.gets.chomp
      rescue
      end

      if (twitter_pin.nil?) || (twitter_pin.length == 0)
        puts "\n\tERROR: Could not read PIN, auth fail"
        return
      end

      begin
        OAuth::RequestToken.new(consumer, rtoken, rsecret)
        access_token = request_token.get_access_token(:oauth_verifier => twitter_pin)
      rescue Twitter::Unauthorized
        puts "> FAIL!"
        return
      end

      # saves the config back to yaml file.
      self.runner.config.do_configure!('twitter', { 'enabled'      => true,
                                                    'access_token' => access_token.token,
                                                    'secret'       => access_token.secret })
    end

    def run
      commit_msg = self.runner.message
      available_commit_msg_size = 128 
      tweet_msg = commit_msg.length > available_commit_msg_size ? "#{commit_msg[0..(available_commit_msg_size-3)]}..." : commit_msg
      tweet_text = "#{tweet_msg} #lolcommits"
      puts "Tweeting: #{tweet_text}"

      if configuration['access_token'].nil? || configuration['secret'].nil?
        initial_twitter_auth()
      end

      if configuration['access_token'].nil? || configuration['secret'].nil?
        puts "Missing Twitter Credentials - Skipping The Tweet"
        return
      end

      Twitter.configure do |config|
        config.consumer_key = TWITTER_CONSUMER_KEY
        config.consumer_secret = TWITTER_CONSUMER_SECRET
      end

      client = Twitter::Client.new(
        :oauth_token => configuration['access_token'],
        :oauth_token_secret => configuration['secret']
      )
      retries = 2
      begin
        if client.update_with_media(tweet_text, File.open(self.runner.main_image, 'r'))
          puts "\t--> Tweet Sent!"
        end
      rescue Twitter::Error::InternalServerError
        retries -= 1
        retry if retries > 0
        puts "\t ! --> Tweet 500 Error - Tweet Not Posted"
      end
    end
  end
end
