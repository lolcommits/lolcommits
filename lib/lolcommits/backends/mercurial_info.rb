# -*- encoding : utf-8 -*-
module Lolcommits
  class MercurialInfo < VCSInfo
    attr_accessor :sha, :message, :repo_internal_path, :repo, :url,
                  :author_name, :author_email, :branch

    def self.repo_root?(path = '.')
      File.directory?(File.join(path, '.hg'))
    end

    def self.local_name(path = '.')
      File.basename(File.dirname(Mercurial::Repository.open(path).dothg_path))
    end

    def initialize
      # mercurial sets HG_RESULT for post- hooks
      if ENV.key?('HG_RESULT') && ENV['HG_RESULT'] != '0'
        debug 'Aborting lolcommits hook from failed operation'
        exit 1
      end

      Mercurial.configure do |conf|
        conf.hg_binary_path = 'hg'
      end
      debug 'MercurialInfo: parsed the following values from commit:'
      debug "MercurialInfo: \t#{message}"
      debug "MercurialInfo: \t#{sha}"
      debug "MercurialInfo: \t#{repo_internal_path}"
      debug "MercurialInfo: \t#{repo}"
      debug "MercurialInfo: \t#{branch}"
      debug "MercurialInfo: \t#{author_name}" if author_name
      debug "MercurialInfo: \t#{author_email}" if author_email
    end

    def branch
      @branch ||= last_commit.branch_name
    end

    def message
      @message ||= begin
        message = last_commit.message || ''
        message.split("\n").first
      end
    end

    def sha
      @sha ||= last_commit.id[0..10]
    end

    def repo_internal_path
      @repo_internal_path ||= repository.dothg_path
    end

    def url
      @url ||= repository.path
    end

    def repo
      @repo ||= File.basename(File.dirname(repo_internal_path))
    end

    def author_name
      @author_name ||= last_commit.author
    end

    def author_email
      @author_email ||= last_commit.author_email
    end

    private

    def repository(path = '.')
      @repository ||= Mercurial::Repository.open(path)
    end

    def last_commit
      @commit ||= repository.commits.parent
    end
  end
end
