# -*- encoding : utf-8 -*-
module Lolcommits
  class GitInfo < VCSInfo
    attr_accessor :sha, :message, :repo_internal_path, :repo, :url,
                  :author_name, :author_email, :branch

    GIT_URL_REGEX = %r{.*[:]([\/\w\-]*).git}

    def self.repo_root?(path = '.')
      File.directory?(File.join(path, '.git'))
    end

    def self.local_name(path = '.')
      File.basename(Git.open(path).dir.to_s)
    end

    def initialize
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
      @branch ||= repository.current_branch
    end

    def message
      @message ||= begin
        message = last_commit.message || ''
        message.split("\n").first
      end
    end

    def sha
      @sha ||= last_commit.sha[0..10]
    end

    def repo_internal_path
      @repo_internal_path ||= repository.repo.path
    end

    def url
      @url ||= begin
        remote_https_url(repository.remote.url) if repository.remote
      end
    end

    def repo
      @repo ||= begin
        if repository.remote && repository.remote.url
          match = repository.remote.url.match(GIT_URL_REGEX)
        end

        if match
          match[1]
        elsif !repository.repo.path.empty?
          repository.repo.path.split(File::SEPARATOR)[-2]
        end
      end
    end

    def author_name
      @author_name ||= last_commit.author.name if last_commit.author
    end

    def author_email
      @author_email ||= last_commit.author.email if last_commit.author
    end

    private

    def remote_https_url(url)
      url.tr(':', '/').tr(/^git@/, 'https://').tr(/\.git$/, '') + '/commit/'
    end

    def repository(path = '.')
      @repository ||= Git.open(path)
    end

    def last_commit
      @commit ||= repository.log.first
    end
  end
end
