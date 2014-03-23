require 'json'
require 'oauth'
require 'laraib'
require 'faraday'

PUMP_CLIENT = "lolcommits"

module Lolcommits

  class LolPumpio < Plugin

    attr_accessor :runner, :options

    def initialize(runner)
      debug "Initializing"
      self.runner = runner
      self.options = ['enabled']
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
      puts "-------------------------------------"
      puts "Need to authorize this Pump.io client"
      puts "-------------------------------------"
      # This logics is heavily based on laraib's bin/laraib-genconf
      puts "\n1.) Enter Pump base URL:"
      begin
        STDOUT.flush
        pumpio_url = STDIN.gets.chomp.chomp("/")
      rescue
      end
      puts "\n2.) Enter Pump username:"
      begin
        STDOUT.flush
        pumpio_user = STDIN.gets.chomp
      rescue
      end
      puts "\n3.) Registering client..."
      connection = Faraday.new(:url => pumpio_url) do |faraday|
	      faraday.request  :url_encoded
	      faraday.response :logger
	      faraday.adapter  Faraday.default_adapter
      end

      raw_registration = connection.post do |req|
	      req.url '/api/client/register'
	      req.headers['Content-Type'] = 'application/json'
	      req.body = JSON.generate({"type" => "client_associate", "application_name" => PUMP_CLIENT, "application_type" => "native"})
      end

      pumpio_registration  = JSON.parse(raw_registration.body)
      pumpio_consumer      = OAuth::Consumer.new(pumpio_registration.fetch("client_id"), pumpio_registration.fetch("client_secret"), {:site => pumpio_url})
      pumpio_request_token = pumpio_consumer.get_request_token

      puts "\n4.) Open the following url in your browser, get the verifier:\n"
      puts pumpio_request_token.authorize_url
      puts "\n5.) Enter verifier, then press enter:"

      begin
        STDOUT.flush
        pumpio_verifier = STDIN.gets.chomp
      rescue
      end

      if (pumpio_verifier.nil?) || (pumpio_verifier.length == 0)
        puts "\n\tERROR: Could not read verifier, auth fail"
        return
      end

      pumpio_access_token = pumpio_request_token.get_access_token(:oauth_verifier => pumpio_verifier)

      return {
	      :url             => pumpio_url,
	      :user            => pumpio_user,
	      :consumer_key    => pumpio_access_token.consumer.key,
	      :consumer_secret => pumpio_access_token.consumer.secret,
	      :token           => pumpio_access_token.params[:oauth_token],
	      :token_secret    => pumpio_access_token.params[:oauth_token_secret]
      }
    end

    def is_configured?
      !configuration['enabled'].nil? &&
        configuration[:url] &&
        configuration[:user] &&
        configuration[:consumer_key] &&
        configuration[:consumer_secret] &&
        configuration[:token] &&
        configuration[:token_secret]
    end

    def run
      return unless valid_configuration?

      display_name = self.runner.message
      content = self.runner.details

      client = Laraib::Client.new(configuration)

      puts "Pumping: #{display_name}"
      begin
	      debug "Uploading image to /api/user/#{configuration[:user]}/uploads..."
	      image_object = client.post(
		      "/api/user/#{configuration[:user]}/uploads",
		      File.open(self.runner.main_image, 'r'), "image/jpeg")

	      note = {"verb" => "post",
		      "object" => {
			      "id" => image_object["id"],
			      "objectType" => "image",
			      "displayName" => display_name,
			      "content" => content,
			      "image" => image_object["image"],
		      },
	      }
	      debug "Posting #{note} to /api/user/#{configuration[:user]}/feed..."
	      post_resp = client.post("/api/user/#{configuration[:user]}/feed", JSON.dump(note))

	      post_resp["verb"] = "update"
	      post_resp["object"]["displayName"] = display_name
	      post_resp["object"]["content"] = content
	      debug "Posting #{note} to /api/user/#{configuration[:user]}/feed..."
	      update_resp = client.post("/api/user/#{configuration[:user]}/feed", JSON.dump(post_resp))
	      debug "Pumped: #{update_resp["object"]["id"]}"

      rescue Exception => e
	      puts "Error pumping: #{e}"
      end
    end

    def self.name
	    'pumpio'
    end

  end
end

# vim: sw=2
