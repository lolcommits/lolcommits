# -*- encoding : utf-8 -*-
module Lolcommits
  class GitInfo
    include Methadone::CLILogging
    attr_accessor :sha, :message, :repo_internal_path, :repo, :url

    def remote_https_url(url)
      url.gsub(':', '/').gsub(/^git@/, 'https://').gsub(/\.git$/, '') + '/commit/'
    end

    def initialize
      debug 'GitInfo: attempting to read local repository'
      g    = Git.open('.')
      debug 'GitInfo: reading commits logs'
      commit = g.log.first
      debug "GitInfo: most recent commit is '#{commit}'"

      self.message = commit.message.split("\n").first
      self.sha     = commit.sha[0..10]
      self.repo_internal_path = g.repo.path
      self.url = remote_https_url(g.remote.url) if g.remote.url

      regex = /.*[:]([\/\w\-]*).git/
      match = g.remote.url.match regex if g.remote.url
      if match
        self.repo = match[1]
      elsif !g.repo.path.empty?
        self.repo = g.repo.path.split(File::SEPARATOR)[-2]
      end

      debug 'GitInfo: parsed the following values from commit:'
      debug "GitInfo: \t#{self.message}"
      debug "GitInfo: \t#{self.sha}"
      debug "GitInfo: \t#{self.repo_internal_path}"
      debug "GitInfo: \t#{self.repo}"
    end
  end
end
