# -*- encoding : utf-8 -*-
module Lolcommits
  module Plugin
    class Loltext < Base
      DEFAULT_FONT_PATH = File.join(Configuration::LOLCOMMITS_ROOT, 'vendor', 'fonts', 'Impact.ttf')

      def self.name
        'loltext'
      end

      # enabled by default (if no configuration exists)
      def enabled?
        !configured? || super
      end

      def run_postcapture
        debug 'Annotating image via MiniMagick'
        image = MiniMagick::Image.open(runner.main_image)
        if config_option(:overlay, :enabled)
          image.combine_options do |c|
            c.fill config_option(:overlay, :overlay_colors).sample
            c.colorize config_option(:overlay, :overlay_percent)
          end
        end

        annotate(image, :message, clean_msg(runner.message))
        annotate(image, :sha, runner.sha)
        debug "Writing changed file to #{runner.main_image}"
        image.write runner.main_image
      end

      def annotate(image, type, string)
        debug("annotating #{type} to image with #{string}")

        transformed_position = position_transform(config_option(type, :position))
        annotate_location = '0'
        if transformed_position == 'South'
          annotate_location = '+0+20' # Move South gravity off the edge of the image.
        end

        string.upcase! if config_option(type, :uppercase)

        image.combine_options do |c|
          c.strokewidth runner.capture_animated? ? '1' : '2'
          c.interline_spacing(-(config_option(type, :size) / 5))
          c.stroke config_option(type, :stroke_color)
          c.fill config_option(type, :color)
          c.gravity transformed_position
          c.pointsize runner.capture_animated? ? (config_option(type, :size) / 2) : config_option(type, :size)
          c.font config_option(type, :font)
          c.annotate annotate_location, string
        end
      end

      def configure_options!
        options = super
        # ask user to configure text options when enabling
        if options['enabled']
          puts '---------------------------------------------------------------'
          puts '  LolText options '
          puts ''
          puts '  * any blank options will use the (default)'
          puts '  * always use the full absolute path to fonts'
          puts '  * valid text positions are NE, NW, SE, SW, S, C (centered)'
          puts '  * colors can be hex #FC0 value or a string \'white\''
          puts '      - use `none` for no stroke color'
          puts '  * overlay fills your image with a random color'
          puts '      - set one or more overlay_colors with a comma seperator'
          puts '      - overlay_percent (0-100) sets the fill colorize strength'
          puts '---------------------------------------------------------------'

          options[:message] = configure_sub_options(:message)
          options[:sha]     = configure_sub_options(:sha)
          options[:overlay] = configure_sub_options(:overlay)
        end
        options
      end

      # TODO: consider this type of configuration prompting in the base Plugin
      # class, working with hash of defaults
      def configure_sub_options(type)
        print "#{type}:\n"
        defaults = config_defaults[type]

        # sort option keys since different `Hash#keys` varys across Ruby versions
        defaults.keys.sort_by(&:to_s).reduce({}) do |acc, opt|
          # if we have an enabled key set to false, abort asking for any more options
          if acc.key?(:enabled) && acc[:enabled] != true
            acc
          else
            print "  #{opt.to_s.tr('_', ' ')} (#{defaults[opt]}): "
            val = parse_user_input(STDIN.gets.chomp.strip)
            # handle array options (comma seperated string)
            if defaults[opt].is_a?(Array) && !val.nil?
              val = val.split(',').map(&:strip).delete_if(&:empty?)
            end
            acc.merge(opt => val)
          end
        end
      end

      def config_defaults
        {
          message: {
            color: 'white',
            font: DEFAULT_FONT_PATH,
            position: 'SW',
            size: 48,
            stroke_color: 'black',
            uppercase: false
          },
          sha: {
            color: 'white',
            font: DEFAULT_FONT_PATH,
            position: 'NE',
            size: 32,
            stroke_color: 'black',
            uppercase: false
          },
          overlay: {
            enabled: false,
            overlay_colors: [
              '#2e4970', '#674685', '#ca242f', '#1e7882', '#2884ae', '#4ba000',
              '#187296', '#7e231f', '#017d9f', '#e52d7b', '#0f5eaa', '#e40087',
              '#5566ac', '#ed8833', '#f8991c', '#408c93', '#ba9109'
            ],
            overlay_percent: 50
          }
        }
      end

      def config_option(type, option)
        default_option = config_defaults[type][option]
        if configuration[type]
          configuration[type][option] || default_option
        else
          default_option
        end
      end

      private

      # explode psuedo-names for text position
      def position_transform(position)
        case position
        when 'NE'
          'NorthEast'
        when 'NW'
          'NorthWest'
        when 'SE'
          'SouthEast'
        when 'SW'
          'SouthWest'
        when 'C'
          'Center'
        when 'S'
          'South'
        end
      end

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
end
