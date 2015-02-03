# -*- encoding : utf-8 -*-
module Lolcommits
  class GitInfo
    include Methadone::CLILogging
    attr_accessor :sha, :message, :repo_internal_path, :repo, :url,
                  :author_name, :author_email, :branch

    GIT_URL_REGEX = /.*[:]([\/\w\-]*).git/

    def initialize
      debug 'GitInfo: reading commits logs'


      self.sha     = commit.sha[0..10]
      self.repo_internal_path = repository.repo.path

      if repository.remote.url
        self.url = remote_https_url(repository.remote.url)
        match = repository.remote.url.match(GIT_URL_REGEX)
      end

      if match
        self.repo = match[1]
      elsif !repository.repo.path.empty?
        self.repo = repository.repo.path.split(File::SEPARATOR)[-2]
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

    def branch
      self.branch ||= repository.current_branch
    end

    def message
      self.message ||= last_commit.message.split("\n").first
    end

    private

    def remote_https_url(url)
      url.gsub(':', '/').gsub(/^git@/, 'https://').gsub(/\.git$/, '') + '/commit/'
    end

    def repository(path = '.')
      Git.open(path)
    end

    def last_commit
      @commit ||= repository.log.first
    end
  end
end
