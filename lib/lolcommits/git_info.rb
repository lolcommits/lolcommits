module Lolcommits
  class GitInfo
    attr_accessor :sha, :message
    def initialize
      git    = Git.open('.')
      commit = git.log.first

      self.message = commit.message.split("\n").first
      self.sha     = commit.sha[0..10]
    end
  end
end
