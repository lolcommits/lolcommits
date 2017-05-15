require 'lolcommits/cli/command'
require 'lolcommits/cli/fatals'
require 'lolcommits/cli/launcher'

module Lolcommits
  module CLI

    class HistoryCommand < Command
      subcommand ['dir', 'path'], 'stored lolcommits for current repo' do
        option '--open', :flag, 'open directory for display in OS'
        def execute
          Fatals.die_if_not_vcs_repo!
          # change_dir_to_root_or_repo!
          config = Configuration.new(PluginManager.init)
          puts config.loldir
          Launcher.open_folder(config.loldir) if open?
        end
      end

      subcommand 'last', 'most recent lolcommit for current repo' do
        option '--open', :flag, 'open file for display in OS'
        def execute
          Fatals.die_if_not_vcs_repo!
          # change_dir_to_root_or_repo!
          config = Configuration.new(PluginManager.init)
          lolimage = Dir.glob(File.join(config.loldir, '*.{jpg,gif}')).max_by { |f| File.mtime(f) }
          if lolimage.nil?
            warn 'No lolcommits have been captured for this repository yet.'
            exit 1
          end
          puts lolimage
          Launcher.open_image(lolimage) if open?
        end
      end

      subcommand 'timelapse', 'generate animated timelapse .gif' do
        def execute
          Fatals.die_if_not_vcs_repo!
          # change_dir_to_root_or_repo!
          config = Configuration.new(PluginManager.init)
          TimelapseGif.new(config).run(options[:period])
        end
      end
    end

  end
end
