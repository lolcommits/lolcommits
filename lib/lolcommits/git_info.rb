# -*- encoding : utf-8 -*-
module Lolcommits
  class GitInfo
    include Methadone::CLILogging
    attr_accessor :sha, :message, :repo_internal_path, :repo, :url,
                  :author_name, :author_email, :branch

    GIT_URL_REGEX = /.*[:]([\/\w\-]*).git/

    def initialize
      debug 'GitInfo: attempting to read local repository'
      g    = Git.open('.')
      debug 'GitInfo: reading commits logs'
      commit = g.log.first
      debug "GitInfo: most recent commit is '#{commit}'"

      self.branch  = g.current_branch
      self.message = commit.message.split("\n").first
      self.sha     = commit.sha[0..10]
      self.repo_internal_path = g.repo.path

      if g.remote.url
        self.url = remote_https_url(g.remote.url)
        match = g.remote.url.match(GIT_URL_REGEX)
      end

      if match
        self.repo = match[1]
      elsif !g.repo.path.empty?
        self.repo = g.repo.path.split(File::SEPARATOR)[-2]
      end

      if commit.author
        self.author_name = commit.author.name
        self.author_email = commit.author.email
      end

      debug 'GitInfo: parsed the following values from commit:'
      debug "GitInfo: \t#{message}"
      debug "GitInfo: \t#{sha}"
      debug "GitInfo: \t#{repo_internal_path}"
      debug "GitInfo: \t#{repo}"
      debug "GitInfo: \t#{branch}"
      debug "GitInfo: \t#{author_name}" if author_name
      debug "GitInfo: \t#{author_email}" if author_email
    end

    private

    def remote_https_url(url)
      url.gsub(':', '/').gsub(/^git@/, 'https://').gsub(/\.git$/, '') + '/commit/'
    end
  end
end
