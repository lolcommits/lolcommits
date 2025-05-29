require "lolcommits/cli/fatals"
require "mini_magick"

module Lolcommits
  module CLI
    # Creates an animated timeline GIF of lolcommits history.
    class TimelapseGif
      # param loldir [String] path to loldir
      def initialize(loldir)
        self.loldir = loldir
      end

      # Runs the history timeline animator task thingy
      # param args [String] the arg passed to the gif command on CLI (optional)
      def run(args = nil)
        case args
        when "today"
          lolimages = jpg_images_today
          filename  = Date.today.to_s
        else
          lolimages = jpg_images
          filename  = "all-until-#{Time.now.strftime('%d-%b-%Y--%Hh%Mm%Ss')}"
        end

        if lolimages.empty?
          warn "No lolcommits have been captured for this time yet."
          exit 1
        end

        puts "*** Generating animated timelapse gif."

        gif_path = File.join(timelapses_dir_path, "#{filename}.gif")

        MiniMagick.convert do |convert|
          convert.delay 50
          convert.loop 0
          lolimages.each { |image| convert << image }
          convert << gif_path
        end

        puts "*** Done, generated at #{gif_path}"
      end

      private
        attr_accessor :loldir

        def jpg_images
          Dir.glob(File.join(loldir, "*.jpg")).sort_by { |f| File.mtime(f) }
        end

        def jpg_images_today
          jpg_images.select { |f| Date.parse(File.mtime(f).to_s) == Date.today }
        end

        def timelapses_dir_path
          dir = File.join(loldir, "timelapses")
          FileUtils.mkdir_p(dir)
          dir
        end
    end
  end
end
