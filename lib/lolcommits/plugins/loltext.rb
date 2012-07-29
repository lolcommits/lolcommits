module Lolcommits
  class Loltext < Plugin
    include Magick

    def initialize(runner)
      super

      self.name    = 'loltext'
      self.default = true
    end

    def run
      canvas = ImageList.new(self.runner.main_image)
      draw = Magick::Draw.new
      draw.font = File.join(Configuration::LOLCOMMITS_ROOT, "fonts", "Impact.ttf")

      draw.fill   = 'white'
      draw.stroke = 'black'

      draw.annotate(canvas, 0, 0, 0, 0, self.runner.sha) do
        self.gravity = NorthEastGravity
        self.pointsize = 32
        self.stroke_width = 2
      end

      draw.annotate(canvas, 0, 0, 0, 0, word_wrap(self.runner.message)) do
        self.gravity = SouthWestGravity
        self.pointsize = 48
        self.interline_spacing = -(48 / 5) if self.respond_to?(:interline_spacing)
        self.stroke_width = 2
      end

      canvas.write(runner.main_image)
    end

    private

    # convenience method for word wrapping
    # based on https://github.com/cmdrkeene/memegen/blob/master/lib/meme_generator.rb
    def word_wrap(text, col = 27)
      wrapped = text.gsub(/(.{1,#{col + 4}})(\s+|\Z)/, "\\1\n")
      wrapped.chomp!
    end
  end
end
