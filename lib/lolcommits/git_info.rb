module Lolcommits
  class GitInfo
    attr_accessor :sha, :message, :repo
    def initialize
      git    = Git.open('.')
      commit = git.log.first

      self.message = commit.message.split("\n").first
      self.sha     = commit.sha[0..10]
      self.repo    = git.remote.url.split(':').last.gsub(/\.git\Z/, '') if git.remote.url
    end
  end
end
