module Lolcommits
  class GitInfo
    attr_accessor :sha, :message, :repo
    def initialize
      g = Git.open('.')
      commit = g.log.first
      self.message = commit.message.split("\n").first
      self.sha = commit.sha[0..10]
      self.repo = Git.open('.').remote.url.split(':').last.gsub(/\.git\Z/, '')
    end
  end
end
