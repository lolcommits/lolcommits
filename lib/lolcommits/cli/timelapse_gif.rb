# -*- encoding: utf-8 -*-
require 'lolcommits/cli/fatals'

require 'mini_magick'

module Lolcommits
  module CLI
    # Creates an animated timeline GIF of lolcommits history.
    class TimelapseGif
      # param config [Lolcommits::Configuration]
      def initialize(config)
        @configuration = config
      end

      # Runs the history timeline animator task thingy
      # param args [String] the arg passed to the gif command on CLI (optional)
      def run(args = nil)
        case args
        when 'today'
          lolimages = @configuration.jpg_images_today
          filename  = "#{Date.today}.gif"
        else
          lolimages = @configuration.jpg_images
          filename  = 'archive.gif'
        end

        if lolimages.empty?
          warn 'No lolcommits have been captured for this time yet.'
          exit 1
        end

        puts '*** Generating animated gif.'

        gif = MiniMagick::Image.new File.join @configuration.archivedir, filename

        # This is for ruby 1.8.7, *lolimages just doesn't work with ruby 187
        gif.run_command('convert', *['-delay', '50', '-loop', '0', lolimages, gif.path.to_s].flatten)

        puts "*** #{gif.path} generated."
      end
    end
  end
end
