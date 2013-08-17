module Lolcommits
  class GitInfo
    include Methadone::CLILogging
    attr_accessor :sha, :message, :details, :repo_internal_path, :repo

    def initialize
      debug "GitInfo: attempting to read local repository"
      g    = Git.open('.')
      debug "GitInfo: reading commits logs"
      commit = g.log.first
      debug "GitInfo: most recent commit is '#{commit}'"

      self.message = commit.message.split("\n").first
      self.details = commit.message.split(self.message)[1]
      self.details = self.details.strip if not self.details.nil?
      self.sha     = commit.sha[0..10]
      self.repo_internal_path = g.repo.path
      regex = /.*[:\/](\w*).git/
      match = g.remote.url.match regex if g.remote.url
      self.repo = match[1] if match
      
      debug "GitInfo: parsed the following values from commit:"
      debug "GitInfo: \t#{self.message}"
      debug "GitInfo: \t#{self.details}"
      debug "GitInfo: \t#{self.sha}"
      debug "GitInfo: \t#{self.repo_internal_path}" 
      debug "GitInfo: \t#{self.repo}"
    end
  end
end
