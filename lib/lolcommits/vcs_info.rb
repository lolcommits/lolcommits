# -*- encoding : utf-8 -*-
module Lolcommits
  # base class ala plugin.rb
  class VCSInfo
    include Methadone::CLILogging
    attr_accessor :sha, :message, :repo_internal_path, :repo, :url,
                  :author_name, :author_email, :branch

    def initialize
      puts 'Base VCS, no implementation'
    end

    def branch
      puts 'Base VCS, no implementation'
    end

    def message
      puts 'Base VCS, no implementation'
    end

    def sha
      puts 'Base VCS, no implementation'
    end

    def repo_internal_path
      puts 'Base VCS, no implementation'
    end

    def url
      puts 'Base VCS, no implementation'
    end

    def repo
      puts 'Base VCS, no implementation'
    end

    def author_name
      puts 'Base VCS, no implementation'
    end

    def author_email
      puts 'Base VCS, no implementation'
    end
  end
end
