require "tranzlate/lolspeak"
require "RMagick"
include Magick

module Lolcommits

  class ImageProcessor

    def initialize( source_img, loldir )
      @source_img, @loldir = source_img, loldir
    end

    # Resizes and annotates a source image into the final file
    #
    # commit_msg - the commit message for annotation
    # commit_sha - the commit sha for annotation
    #
    # Returns the path to the processed image
    def process!(commit_msg, commit_sha)
      # read in the image, and resize it via the canvas
      canvas = ImageList.new( @source_img )
      if (canvas.columns > 640 || canvas.rows > 480)
        canvas.resize_to_fill!(640,480)
      end

      # create a draw object for annotation
      draw = Magick::Draw.new
      draw.font = File.join(LOLCOMMITS_ROOT, "fonts", "Impact.ttf")
      draw.fill = 'white'
      draw.stroke = 'black'
      draw.stroke_width = 2

      draw.annotate(canvas, 0, 0, 0, 0, commit_sha) do
        self.gravity = NorthEastGravity
        self.pointsize = 32
      end

      draw.annotate(canvas, 0, 0, 0, 0, ImageProcessor.word_wrap(commit_msg)) do
        self.gravity = SouthWestGravity
        self.pointsize = 48
        self.interline_spacing = -(48 / 5) if self.respond_to?(:interline_spacing)
      end

      #
      # Squash the images and write the files
      #
      target = File.join @loldir, "#{commit_sha}.jpg"
      canvas.write( target )
      @processed_img = target
    end

    # convenience method for word wrapping
    # based on https://github.com/cmdrkeene/memegen/blob/master/lib/meme_generator.rb
    def self.word_wrap(text, col = 27)
      wrapped = text.gsub(/(.{1,#{col + 4}})(\s+|\Z)/, "\\1\n")
      wrapped.chomp!
    end

  end

end