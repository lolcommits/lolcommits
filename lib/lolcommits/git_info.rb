module Lolcommits
  class GitInfo
    attr_accessor :sha, :message
    def initialize
      g = Git.open('.')
      commit = g.log.first
      self.message = commit.message.split("\n").first
      self.sha = commit.sha[0..10]
    end
  end
end
