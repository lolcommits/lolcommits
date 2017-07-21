require 'launchy'

module Lolcommits
  module CLI
    # Helper class for wrapping the opening of files on the desktop in a
    # cross-platform way.
    #
    # Right now this is mostly just a wrapper for Launchy, in case we want
    # to factor out it's dependency later or swap it out.
    class Launcher
      def self.open_image(path)
        open_with_launchy(path)
      end

      def self.open_folder(path)
        open_with_launchy(path)
      end

      def self.open_url(url)
        open_with_launchy(url)
      end

      # Opens with Launchy, which knows how to open pretty much anything
      # local files, urls, etc.
      #
      # Private so we replace it later easier if we want.
      def self.open_with_launchy(thing)
        Launchy.open(thing)
      end
    end
  end
end
