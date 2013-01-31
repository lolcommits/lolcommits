module Lolcommits
  class GitInfo
    include Methadone::CLILogging
    attr_accessor :sha, :message, :repo_internal_path

    def initialize
      debug "GitInfo: attempting to read local repository"
      g    = Git.open('.')
      debug "GitInfo: reading commits logs"
      commit = g.log.first
      debug "GitInfo: most recent commit is '#{commit}'"

      self.message = commit.message.split("\n").first
      self.sha     = commit.sha[0..10]
      self.repo_internal_path = g.repo.path
      
      debug "GitInfo: parsed the following values from commit:"
      debug "GitInfo: \t#{self.message}"
      debug "GitInfo: \t#{self.sha}"
      debug "GitInfo: \t#{self.repo_internal_path}" 
    end
  end
end
