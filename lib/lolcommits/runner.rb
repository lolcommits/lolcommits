module Lolcommits
  class Runner
    attr_accessor :capture_delay, :capture_device, :message, :sha,
      :snapshot_loc

    def initialize(attributes={})
      attributes.each do |attr, val|
        self.send("#{attr}=", val)
      end
      
      git_info = GitInfo.new
      self.sha = git_info.sha if self.sha.nil?
      self.message = git_info.message if self.message.nil?
    end


    def run
      if (ENV['LOLCOMMITS_TRANZLATE'] == '1' || false)
        self.message = message.tranzlate
      end

      #
      # Create a directory to hold the lolimages
      #
      if not File.directory? Configuration.loldir
        FileUtils.mkdir_p Configuration.loldir
      end

      #
      # SMILE FOR THE CAMERA! 3...2...1...
      # We're just assuming the captured image is 640x480 for now, we may
      # need updates to the imagesnap program to manually set this (or resize)
      # if this changes on future mac isights.
      #
      puts "*** Preserving this moment in history."
      self.snapshot_loc = Configuration.raw_image(self.sha) 

      capturer = "Lolcommits::Capture#{Configuration.platform}".constantize.new(
        :capture_device    => self.capture_device, 
        :capture_delay     => self.capture_delay, 
        :snapshot_location => self.snapshot_loc
      )
      capturer.capture


      #
      # Process the image with ImageMagick to add loltext
      #

      # read in the image, and resize it via the canvas
      canvas = ImageList.new("#{self.snapshot_loc}")
      if (canvas.columns > 640 || canvas.rows > 480)
        canvas.resize_to_fill!(640,480)
      end

      draw = Magick::Draw.new
      draw.font = File.join(Configuration::LOLCOMMITS_ROOT, "fonts", "Impact.ttf")

      draw.fill = 'white'
      draw.stroke = 'black'

      # convenience method for word wrapping
      # based on https://github.com/cmdrkeene/memegen/blob/master/lib/meme_generator.rb
      def word_wrap(text, col = 27)
        wrapped = text.gsub(/(.{1,#{col + 4}})(\s+|\Z)/, "\\1\n")
          wrapped.chomp!
      end

      draw.annotate(canvas, 0, 0, 0, 0, self.sha) do
        self.gravity = NorthEastGravity
        self.pointsize = 32
        self.stroke_width = 2
      end

      draw.annotate(canvas, 0, 0, 0, 0, word_wrap(self.message)) do
        self.gravity = SouthWestGravity
        self.pointsize = 48
        self.interline_spacing = -(48 / 5) if self.respond_to?(:interline_spacing)
        self.stroke_width = 2
      end

      #
      # Squash the images and write the files
      #
      #canvas.flatten_images.write("#{Configuration.loldir}/#{self.sha}.jpg")
      canvas.write(File.join Configuration.loldir, "#{self.sha}.jpg")

      HTTMultiParty.post('http://freezing-day-1419.herokuapp.com/git_commits.json', 
                         :body => {
        :git_commit => {
        :sha => self.sha,
        :repo => 'omg', 
        :image => File.open(File.join(Configuration.loldir, "#{self.sha}.jpg"))
      }
      })

      self.sha
    end
  end
end
