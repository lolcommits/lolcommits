require 'httmultiparty'

module Lolcommits
  class DotCom < Plugin

    def initialize(runner)
      super
      self.options.concat(['api_key', 'api_secret', 'repo_id'])
    end

    def run
      return unless valid_configuration?

      t = Time.now.to_i.to_s
      resp = HTTMultiParty.post('http://www.lolcommits.com/git_commits.json',
        :body => {
          :git_commit => {
            :sha              => self.runner.sha,
            :repo_external_id => configuration['repo_id'],
            :image            => File.open(self.runner.main_image),
            :raw              => File.open(self.runner.snapshot_loc)
          },

          :key   => configuration['api_key'],
          :t     => t,
          :token =>  Digest::SHA1.hexdigest(configuration['api_secret'] + t)
        }
      )
    end

    def is_configured?
      !configuration['enabled'].nil? &&
        configuration['api_key'] &&
        configuration['api_secret'] &&
        configuration['repo_id']
    end

    def self.name
      'dot_com'
    end
  end
end
