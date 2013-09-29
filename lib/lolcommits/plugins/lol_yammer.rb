require 'yammer'
require 'addressable/uri'

# Getting a Token
#
# * Replace the Consumer Key placeholder in this URL: https://www.yammer.com/dialog/oauth?client_id=CONSUMER_KEY, with the Consumer Key from step 1. Then open the URL in a browser.
# * After signing into Yammer and authorizing the application, you will be redirected to https://www.yammer.com?code=CODE. Record the value of the code parameter.
# * Replace the values in this URL with the Consumer Key and Secret (step 1), and the code (step 3): https://www.yammer.com/oauth2/access_token.json?client_id=CONSUMER_KEY&client_secret=CONSUMER_SECRET&code=CODE. Then open the URL in a browser.
# * Your browser should now be displaying a JSON response. Capture the value of the token member as this will be used to make API calls.

YAMMER_CLIENT_ID = 'bgORyeKtnjZJSMwp8oln9g'
YAMMER_CLIENT_SECRET = 'oer2WdGzh74a5QBbW3INUxblHK3yg9KvCZmiBa2r0'
YAMMER_ACCESS_TOKEN_URL = "https://www.yammer.com/oauth2/access_token.json"

# https://www.yammer.com/oauth2/access_token.json?client_id=bgORyeKtnjZJSMwp8oln9g&client_secret=oer2WdGzh74a5QBbW3INUxblHK3yg9KvCZmiBa2r0&code=0LtdfJRtPA05PFXXVLZg

# sample access_token 7eMte1lGK2P6iKKEhaToA

module Lolcommits

  class LolYammer < Plugin

    def initialize(runner)
      super
      self.name    = 'yammer'
      self.default = false
      self.options.concat(['access_token'])
    end

    def run
      if configuration['access_token'].nil?
        puts "Missing Yammer Credentials - Skipping post"
        return
      end

      commit_msg = self.runner.message
      post = "#{commit_msg} #lolcommits"
      puts "Yammer post: #{post}"

      Yammer.configure do |c|
        c.client_id = YAMMER_CLIENT_ID
        c.client_secret = YAMMER_CLIENT_SECRET
      end

      client = Yammer::Client.new(:access_token  => configuration['access_token'])

      retries = 2
      begin
        lolimage = File.new(self.runner.main_image)
        if client.create_message(post, :attachment1 => lolimage)
          puts "\t--> Status posted!"
        end
      rescue => e
        retries -= 1
        retry if retries > 0
        puts "\t ! --> Status not posted - #{e.message}"
      end
    end
  end
end
