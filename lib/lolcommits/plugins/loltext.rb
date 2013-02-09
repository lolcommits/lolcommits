module Lolcommits
  class Loltext < Plugin

    def initialize(runner)
      super

      @font_location = runner.font

      self.name    = 'loltext'
      self.default = true
    end

    def run
      mm_run
    end

    # use minimagick wrapper
    def mm_run
      font_location = @font_location || File.join(Configuration::LOLCOMMITS_ROOT, "vendor", "fonts", "Impact.ttf")

      plugdebug "Annotating image via MiniMagick"
      image = MiniMagick::Image.open(self.runner.main_image)
      image.combine_options do |c|
        c.gravity 'SouthWest'
        c.fill 'white'
        c.stroke 'black'
        c.strokewidth '2'
        c.pointsize '48'
        c.interline_spacing '-9'
        c.font font_location
        c.annotate '0', clean_msg(self.runner.message)
      end

      image.combine_options do |c|
        c.gravity 'NorthEast'
        c.fill 'white'
        c.stroke 'black'
        c.strokewidth '2'
        c.pointsize '32'
        c.font font_location
        c.annotate '0', self.runner.sha
      end

      plugdebug "Writing changed file to #{self.runner.main_image}"
      image.write self.runner.main_image
    end

    # use Rmagick wrapper (deprecated, no longer works in IM6.10+)
    # def rm_run
    #   canvas = ImageList.new(self.runner.main_image)
    #   draw = Magick::Draw.new
    #   draw.font = File.join(Configuration::LOLCOMMITS_ROOT, "vendor", "fonts", "Impact.ttf")

    #   draw.fill   = 'white'
    #   draw.stroke = 'black'

    #   draw.annotate(canvas, 0, 0, 0, 0, self.runner.sha) do
    #     self.gravity = NorthEastGravity
    #     self.pointsize = 32
    #     self.stroke_width = 2
    #   end

    #   draw.annotate(canvas, 0, 0, 0, 0, word_wrap(self.runner.message)) do
    #     self.gravity = SouthWestGravity
    #     self.pointsize = 48
    #     self.interline_spacing = -(48 / 5) if self.respond_to?(:interline_spacing)
    #     self.stroke_width = 2
    #   end

    #   canvas.write(runner.main_image)
    # end

    private

    # do whatever is required to commit message to get it clean and ready for imagemagick
    def clean_msg(text)
      wrapped_text = word_wrap text
      escape_quotes wrapped_text
    end

    # conversion for quotation marks to avoid shell interpretation
    # does not seem to be a safe way to escape cross-platform?
    def escape_quotes(text)
      text.gsub(/"/, "''")
    end

    # convenience method for word wrapping
    # based on https://github.com/cmdrkeene/memegen/blob/master/lib/meme_generator.rb
    def word_wrap(text, col = 27)
      wrapped = text.gsub(/(.{1,#{col + 4}})(\s+|\Z)/, "\\1\n")
      wrapped.chomp!
    end
  end
end
