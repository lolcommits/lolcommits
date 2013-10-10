require 'yammer'
require 'rest_client'

# https://developer.yammer.com/oauth2-quickstart/

YAMMER_CLIENT_ID = 'bgORyeKtnjZJSMwp8oln9g'
YAMMER_CLIENT_SECRET = 'oer2WdGzh74a5QBbW3INUxblHK3yg9KvCZmiBa2r0'
YAMMER_ACCESS_TOKEN_URL = "https://www.yammer.com/oauth2/access_token.json"

module Lolcommits

  class LolYammer < Plugin

    def initialize(runner)
      super
      self.name    = 'yammer'
      self.default = false
      self.options.concat(['access_token'])
    end

    def set_access_token(code)
      url = "#{YAMMER_ACCESS_TOKEN_URL}?client_id=%s&client_secret=%s&code=%s" % [YAMMER_CLIENT_ID, YAMMER_CLIENT_SECRET, code]
      plugdebug "access_token url: #{url}"
      result = JSON.parse(RestClient.get(url))
      result["access_token"]["token"]
    end

    def run
      if configuration['access_token'].nil?
        puts "Run configuration first:"
        puts "lolcommits --config --plugin yammer"
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
        puts "Status not posted - #{e.message}"
        puts "Try running config again:"
        puts "\tlolcommits --config --plugin yammer"
      end
    end
  end
end
