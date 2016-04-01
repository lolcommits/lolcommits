# -*- encoding : utf-8 -*-
module Lolcommits
  #
  # Methods to handle enabling and disabling of lolcommits
  #
  class Installation
    def self.backend
      if File.directory?('.git')
        InstallationGit
      elsif File.directory?('.hg')
        InstallationMercurial
      end
    end

    #
    # IF --ENABLE, DO ENABLE
    #
    def self.do_enable
      path = backend.do_enable

      info 'installed lolcommit hook to:'
      info "  -> #{File.expand_path(path)}"
      info '(to remove later, you can use: lolcommits --disable)'
      # we dont symlink, but rather install a small stub that calls the one from path
      # that way, as gem version changes, script updates even if new file thus breaking symlink
    end

    #
    # IF --DISABLE, DO DISABLE
    #
    def self.do_disable
      backend.do_disable
    end
  end
end
