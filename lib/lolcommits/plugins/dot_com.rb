module Lolcommits
  class DotCom < Plugin
    def initialize(runner)
      super

      self.name    = 'dot_com'
      self.default = false
    end

    def run
      t = Time.now.to_i.to_s
      resp = HTTMultiParty.post('http://www.lolcommits.com/git_commits.json', 
        :body => {
          :git_commit => {
            :sha   => self.runner.sha,
            :repo  => self.runner.repo, 
            :image => File.open(self.runner.file)
          },

          :key   => configuration['api_key'],
          :t     => t,
          :token =>  Digest::SHA1.hexdigest(configuration['api_secret'] + t)
        }
      )
    end

  end
end
