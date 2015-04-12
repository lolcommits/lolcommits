# -*- encoding : utf-8 -*-
module Lolcommits
  class Loltext < Plugin
    def initialize(runner)
      super
      @font_location = runner ? runner.font : nil
    end

    # enabled by default (if no configuration exists)
    def enabled?
      !configured? || super
    end

    def run_postcapture
      font_location = @font_location || File.join(Configuration::LOLCOMMITS_ROOT,
                                                  'vendor',
                                                  'fonts',
                                                  'Impact.ttf')

      debug 'Annotating image via MiniMagick'
      image = MiniMagick::Image.open(runner.main_image)
      image.combine_options do |c|
        c.gravity 'SouthWest'
        c.fill 'white'
        c.stroke 'black'
        c.strokewidth '2'
        c.pointsize(runner.animate? ? '24' : '48')
        c.interline_spacing '-9'
        c.font font_location
        c.annotate '0', clean_msg(runner.message)
      end

      image.combine_options do |c|
        c.gravity 'NorthEast'
        c.fill 'white'
        c.stroke 'black'
        c.strokewidth '2'
        c.pointsize(runner.animate? ? '21' : '32')
        c.font font_location
        c.annotate '0', runner.sha
      end

      debug "Writing changed file to #{runner.main_image}"
      image.write runner.main_image
    end

    def name
      'loltext'
    end

    private

    # do whatever is required to commit message to get it clean and ready for imagemagick
    def clean_msg(text)
      wrapped_text = word_wrap text
      escape_quotes wrapped_text
      escape_ats wrapped_text
    end

    # conversion for quotation marks to avoid shell interpretation
    # does not seem to be a safe way to escape cross-platform?
    def escape_quotes(text)
      text.gsub(/"/, "''")
    end

    def escape_ats(text)
      text.gsub(/@/, '\@')
    end

    # convenience method for word wrapping
    # based on https://github.com/cmdrkeene/memegen/blob/master/lib/meme_generator.rb
    def word_wrap(text, col = 27)
      wrapped = text.gsub(/(.{1,#{col + 4}})(\s+|\Z)/, "\\1\n")
      wrapped.chomp!
    end
  end
end
