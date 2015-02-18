# -*- encoding: utf-8 -*-
require 'lolcommits/platform'
require 'methadone'

module Lolcommits
  module CLI
    # Helper methods for failing on error conditions in the lolcommits CLI.
    module Fatals
      include Lolcommits
      include Methadone::CLILogging

      # Check for platform related conditions that could prevent lolcommits from
      # working properly.
      #
      # Die with an informative error message if any occur.
      def self.die_on_fatal_platform_conditions!
        # make sure the capture binaries are in a good state
        if Platform.platform_mac?
          %w(imagesnap videosnap).each do |executable|
            next if File.executable? File.join(Configuration::LOLCOMMITS_ROOT, 'vendor', 'ext', executable, executable)
            fatal "Couldn't properly execute #{executable} for some reason, "\
                  "please file a bug?!"
            exit 1
          end
        elsif Platform.platform_linux?
          if not Platform.command_which('mplayer')
            fatal "Couldn't find mplayer in your PATH!"
            exit 1
          end
        end

        # make sure we can find the Impact truetype font
        unless File.readable? File.join(Configuration::LOLCOMMITS_ROOT, 'vendor', 'fonts', 'Impact.ttf')
          fatal "Couldn't properly read Impact font from gem package, "\
                "please file a bug?!"
          exit 1
        end

        # make sure imagemagick is around and good to go
        unless Platform.valid_imagemagick_installed?
          fatal "FATAL: ImageMagick does not appear to be properly installed!"\
                "(or version is too old)"
          exit 1
        end

        # check for a error condition with git config affecting ruby-git
        if Platform.git_config_color_always?
          fatal "Due to a bug in the ruby-git library, git config for color.ui"\
                " cannot be set to 'always'."
          fatal "Try setting it to 'auto' instead!"
          exit 1
        end
      end

      # Die with an informative error message if ffmpeg is not installed.
      # This is only used for certain functions (such as animation), so only run
      # this when you know the user wants to perform one of them.
      def self.die_if_no_valid_ffmpeg_installed!
        if !Platform.valid_ffmpeg_installed?
          fatal 'FATAL: ffmpeg does not appear to be properly installed!'
          exit 1
        end
      end

      # If we are not in a git repo, we can't do git related things!
      # Die with an informative error message in that case.
      def self.die_if_not_git_repo!
        begin
          debug 'Checking for valid git repo'
          g = Git.open('.') #FIXME: should be extracted to GitInfo class
        rescue ArgumentError
          # ruby-git throws an argument error if path isnt for a valid git repo.
          fatal "Erm? Can't do that since we're not in a valid git repository!"
          exit 1
        end
      end
    end
  end
end
