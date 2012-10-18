module Lolcommits
  class GitInfo
    attr_accessor :sha, :message, :repo_internal_path
    def initialize
      g    = Git.open('.')
      commit = g.log.first

      self.message = commit.message.split("\n").first
      self.sha     = commit.sha[0..10]
      self.repo_internal_path = g.repo.path
    end
  end
end
