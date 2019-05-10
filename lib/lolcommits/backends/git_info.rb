# frozen_string_literal: true

module Lolcommits
  class GitInfo
    GIT_URL_REGEX = %r{.*[:]([\/\w\-]*).git}.freeze

    def self.repo_root?(path = '.')
      File.directory?(File.join(path, '.git'))
    end

    def self.local_name(path = '.')
      File.basename(Git.open(path).dir.to_s)
    end

    def initialize
      debug 'parsed the following values from commit:'
      debug "\t#{message}"
      debug "\t#{sha}"
      debug "\t#{repo_internal_path}"
      debug "\t#{repo}"
      debug "\t#{branch}"
      debug "\t#{commit_date}"
      debug "\t#{author_name}" if author_name
      debug "\t#{author_email}" if author_email
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
      @url ||= remote_repo? ? remote_https_url(repository.remote.url) : nil
    end

    def repo
      @repo ||= begin
        match = repository.remote.url.match(GIT_URL_REGEX) if remote_repo?

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

    def commit_date
      @commit_date ||= last_commit.date.utc
    end

    private

    def debug(message)
      super("#{self.class}: #{message}")
    end

    def remote_https_url(url)
      url.tr(':', '/').gsub(/^git@/, 'https://').gsub(/\.git$/, '') + '/commit/'
    end

    def repository(path = '.')
      @repository ||= Git.open(path)
    end

    def last_commit
      @last_commit ||= repository.log.first
    end

    def remote_repo?
      repository.remote && repository.remote.url
    end
  end
end
