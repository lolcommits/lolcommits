require "rest_client"
require "pp"
require "json"
require "logger"

module Lolcommits

  class Lolsrv < Plugin

    SERVER = 'server'

    def initialize(runner)
      super
      self.name    = 'lolsrv'
      self.default = false  
      self.options << SERVER

    end

    def run
      
      log_file = File.new(self.runner.config.loldir + "/lolsrv.log", "a+")
      @logger = Logger.new(log_file)
      
      if configuration[SERVER].nil?
        puts "Missing server configuration. Use lolcommits --config -p lolsrv"
        return
      end

      fork do
        sync()
      end
    end

    def sync
      existing = get_existing_lols
      unless existing.nil?
        Dir.glob(self.runner.config.loldir + "/*.jpg") do |item|
          next if item == '.' or item == '..'
          # do work on real items
          sha = File.basename(item, '.*')
          unless existing.include?(sha) || sha == 'tmp_snapshot' 
            upload(item, sha)
          end
        end
      end
    end

    def get_existing_lols
      begin
        lols = JSON.parse(
        RestClient.get(configuration[SERVER] + '/lols'))
        lols.map { |lol| lol["sha"] }
      rescue => error
        @logger.info "Existing lols could not be retrieved with Error " + error.message
        @logger.info error.backtrace
        return nil
      end
    end

    def upload(file, sha)
      begin
        RestClient.post(
        configuration[SERVER] + '/uplol', 
        :lol => File.new(file),
        :sha => sha) 
      rescue => error
        @logger.info "Upload of LOL "+ sha + " failed with Error " + error.message
        return
      end
    end
  end
end
