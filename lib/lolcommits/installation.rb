# -*- encoding : utf-8 -*-
module Lolcommits
  #
  # Methods to handle enabling and disabling of lolcommits
  #
  class Installation
    @@backend = nil

    #
    # IF --ENABLE, DO ENABLE
    #
    def self.do_enable
      if File.directory?('.git')
        InstallationGit.do_enable
        @@backend = InstallationGit
      end
    end

    #
    # IF --DISABLE, DO DISABLE
    #
    def self.do_disable
      @@backend.do_disable
    end

    def self.hook_script
      @@backend.hook_script
    end

    # does a hook exist at all?
    def self.hook_file_exists?
      @@backend.hook_file_exists?
    end

    # does a hook exist with lolcommits commands?
    def self.lolcommits_hook_exists?
      @@backend.lolcommits_hook_exists?
    end

    # does the hook file have a good shebang?
    def self.good_shebang?
      @@backend.good_shebang?
    end

    def self.remove_existing_hook!
      @@backend.remove_existing_hook!
    end
  end
end
