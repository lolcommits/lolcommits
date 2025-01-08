module Lolcommits
  class MercurialInfo
    def self.repo_root?(path = ".")
      File.directory?(File.join(path, ".hg"))
    end

    def self.local_name(path = ".")
      File.basename(File.dirname(Mercurial::Repository.open(path).dothg_path))
    end

    def initialize
      # mercurial sets HG_RESULT for post- hooks
      if ENV.key?("HG_RESULT") && ENV["HG_RESULT"] != "0"
        debug "Aborting lolcommits hook from failed operation"
        exit 1
      end

      Mercurial.configure do |conf|
        conf.hg_binary_path = "hg"
      end
      debug "parsed the following values from commit:"
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
      @branch ||= last_commit.branch_name
    end

    def message
      @message ||= begin
        message = last_commit.message || ""
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

    def commit_date
      @commit_date ||= last_commit.date.utc
    end

    private

    def debug(message)
      super("#{self.class}: #{message}")
    end

    def repository(path = ".")
      @repository ||= Mercurial::Repository.open(path)
    end

    def last_commit
      @last_commit ||= repository.commits.parent
    end
  end
end
